-- grapplevim: A gravity and grappling hook plugin for Neovim
-- Author: You! (and Gemini)
-- Date: June 25, 2025 (Refactored)

local M = {}

-- ====================================================================
-- 1. State and Configuration
-- ====================================================================

local State = {
  is_active = false,
  timer = nil,
  bufnr = 0,
  winid = 0,
  original_virtualedit = '',
  maps_set = {}, -- Robustly track all keymaps we create

  pos = { x = 0.0, y = 0.0 },
  vel = { x = 0.0, y = 0.0 },

  grapple = {
    active = false,
    anchor = { x = 0, y = 0 },
    rope_length = 0,
    extmark_id = nil, -- To store the ID of our visual anchor
  },
}

local Config = {
  step_rate = 30,
  gravity = 0.1,
  grapple_tension = 0.03,
  grapple_friction = 0.98,
  -- Tuned impulses for more control
  j_impulse = 1.5,
  k_impulse = 0.8, -- Lower value to act as a brake, not a rocket
  hl_impulse = 1.2,
  -- Visuals
  anchor_sign_text = '⚓',
  anchor_sign_highlight = 'WarningMsg',
  -- Keymaps
  map_leader = "<Enter>",
  map_grapple = "<Space>",
}

-- ====================================================================
-- 2. Visuals and Physics
-- ====================================================================

--- Hides the grapple anchor visual by deleting the extmark.
local function hide_grapple_anchor()
  if State.grapple.extmark_id then
    vim.api.nvim_buf_del_extmark(State.bufnr, M.namespace_id, State.grapple.extmark_id)
    State.grapple.extmark_id = nil
  end
end

--- Shows the grapple anchor visual by creating an extmark with a sign.
local function show_grapple_anchor()
  hide_grapple_anchor() -- Clear previous one just in case
  if State.grapple.anchor then
    State.grapple.extmark_id = vim.api.nvim_buf_set_extmark(State.bufnr, M.namespace_id, State.grapple.anchor.y - 1, State.grapple.anchor.x - 1, {
      sign_text = Config.anchor_sign_text,
      sign_hl_group = Config.anchor_sign_highlight,
    })
  end
end

local function find_nearest_anchor()
  -- (This function remains unchanged from the previous version)
  local start_pos = vim.api.nvim_win_get_cursor(0)
  local start_line, start_col = start_pos[1], start_pos[2]
  local max_lines = vim.api.nvim_buf_line_count(0)
  local best_dist_sq = math.huge
  local best_pos = nil
  for i = 0, max_lines do
    for _, sign in ipairs({ 1, -1 }) do
      local line_idx = start_line + (i * sign)
      if line_idx >= 1 and line_idx <= max_lines then
        local line_content = vim.api.nvim_buf_get_lines(0, line_idx - 1, line_idx, false)[1] or ''
        local first, last = line_content:find('%S'), line_content:find('%S.*$')
        if first then
          local closest_col
          if start_col < first then closest_col = first elseif start_col > last then closest_col = last else closest_col = start_col end
          local dist_sq = (line_idx - start_line)^2 + (closest_col - start_col)^2
          if dist_sq > 0 and dist_sq < best_dist_sq then
            best_dist_sq = dist_sq
            best_pos = { y = line_idx, x = closest_col }
          end
        end
      end
    end
    if best_pos and i > math.sqrt(best_dist_sq) then return best_pos end
  end
  return best_pos
end

local function apply_gravity()
  State.vel.y = State.vel.y + Config.gravity
end

local function apply_grapple_physics()
  local dx = State.grapple.anchor.x - State.pos.x
  local dy = State.grapple.anchor.y - State.pos.y
  local dist = math.sqrt(dx * dx + dy * dy)
  if dist > State.grapple.rope_length then
    local tension_dx = dx / dist * (dist - State.grapple.rope_length)
    local tension_dy = dy / dist * (dist - State.grapple.rope_length)
    State.vel.x = State.vel.x + tension_dx * Config.grapple_tension
    State.vel.y = State.vel.y + tension_dy * Config.grapple_tension
  end
  State.vel.x = State.vel.x * Config.grapple_friction
  State.vel.y = State.vel.y * Config.grapple_friction
end

--- Main update loop
local function update()
  if not State.is_active or not vim.api.nvim_win_is_valid(State.winid) then
    M.stop()
    return
  end
  apply_gravity()
  if State.grapple.active then
    apply_grapple_physics()
  end
  State.pos.x = State.pos.x + State.vel.x
  State.pos.y = State.pos.y + State.vel.y

  -- Boundary checks
  local max_lines = vim.api.nvim_buf_line_count(State.bufnr)
  if State.pos.y > max_lines then State.pos.y = max_lines; State.vel.y = 0 end
  if State.pos.y < 1 then State.pos.y = 1; State.vel.y = 0 end
  
  -- NEW: Boundary check against window width because of virtualedit
  local win_width = vim.api.nvim_win_get_width(State.winid)
  if State.pos.x > win_width -1 then State.pos.x = win_width -1; State.vel.x = -State.vel.x * 0.5 end
  if State.pos.x < 0 then State.pos.x = 0; State.vel.x = -State.vel.x * 0.5 end

  vim.api.nvim_win_set_cursor(State.winid, { math.floor(State.pos.y), math.floor(State.pos.x) })
end

-- ====================================================================
-- 3. State Management and Keymaps
-- ====================================================================

local function toggle_grapple()
  if not State.is_active then return end
  State.grapple.active = not State.grapple.active
  if State.grapple.active then
    local anchor_pos = find_nearest_anchor()
    if anchor_pos then
      State.grapple.anchor = anchor_pos
      local dx = State.grapple.anchor.x - State.pos.x; local dy = State.grapple.anchor.y - State.pos.y
      State.grapple.rope_length = math.sqrt(dx * dx + dy * dy)
      show_grapple_anchor() -- Show the visual
      vim.notify("Grapple ENGAGED!", vim.log.levels.INFO)
    else
      State.grapple.active = false
      vim.notify("No anchor point found!", vim.log.levels.WARN)
    end
  else
    hide_grapple_anchor() -- Hide the visual
    vim.notify("Grapple released.", vim.log.levels.INFO)
  end
end

local function handle_impulse(key)
  if key == 'j' then State.vel.y = State.vel.y + Config.j_impulse end
  if key == 'k' then State.vel.y = State.vel.y - Config.k_impulse end -- Use new tuned value
  if key == 'l' then State.vel.x = State.vel.x + Config.hl_impulse end
  if key == 'h' then State.vel.x = State.vel.x - Config.hl_impulse end
end

--- NEW: Robust keymap setting and tracking
local function set_map(mode, key, rhs, desc)
  local map_opts = { buffer = State.bufnr, nowait = true, desc = "[Grapple] " .. desc }
  vim.keymap.set(mode, key, rhs, map_opts)
  -- Track the map so we can safely remove it later
  if not State.maps_set[mode] then State.maps_set[mode] = {} end
  table.insert(State.maps_set[mode], key)
end

local function setup_gravity_maps()
  State.maps_set = {} -- Reset tracker
  set_map('n', Config.map_leader, M.stop, "Stop Gravity")
  set_map('n', Config.map_grapple, toggle_grapple, "Toggle Grapple")
  set_map('n', 'j', function() handle_impulse('j') end, "Impulse Down")
  set_map('n', 'k', function() handle_impulse('k') end, "Impulse Up (Brake)")
  set_map('n', 'h', function() handle_impulse('h') end, "Impulse Left")
  set_map('n', 'l', function() handle_impulse('l') end, "Impulse Right")
  -- Add a few common keys to exit mode cleanly
  set_map('n', '<Esc>', M.stop, "Stop Gravity")
  set_map('n', ':', M.stop, "Stop Gravity")
end

--- NEW: Robust keymap clearing
local function clear_gravity_maps()
  for mode, keys in pairs(State.maps_set) do
    for _, key in ipairs(keys) do
      -- Use pcall for maximum safety, in case a map was already cleared
      pcall(vim.keymap.del, mode, key, { buffer = State.bufnr })
    end
  end
  State.maps_set = {}
end

--- Starts the gravity simulation.
function M.start()
  if State.is_active then return end
  State.is_active = true
  State.winid = vim.api.nvim_get_current_win()
  State.bufnr = vim.api.nvim_get_current_buf()

  -- NEW: Enable virtualedit to allow cursor past end of line
  State.original_virtualedit = vim.o.virtualedit
  vim.o.virtualedit = 'all'

  local cursor_pos = vim.api.nvim_win_get_cursor(State.winid)
  State.pos = { y = cursor_pos[1], x = cursor_pos[2] }
  State.vel = { x = 0, y = 0 }
  State.grapple.active = false

  setup_gravity_maps()
  State.timer = vim.fn.timer_start(Config.step_rate, update, { ['repeat'] = -1 })
  vim.notify("Gravity ON", vim.log.levels.INFO)
  vim.wo[State.winid].cursorline = true
end

--- Stops the gravity simulation.
function M.stop()
  if not State.is_active then return end
  if State.timer then
    vim.fn.timer_stop(State.timer)
    State.timer = nil
  end

  -- NEW: Restore virtualedit to its original state
  vim.o.virtualedit = State.original_virtualedit
  
  vim.wo[State.winid].cursorline = false
  hide_grapple_anchor() -- Ensure anchor sign is gone
  clear_gravity_maps() -- Use the new robust clearing function

  local final_pos = vim.api.nvim_win_get_cursor(State.winid)
  vim.cmd.stopinsert()
  vim.fn.col('.')

  State.is_active = false
  vim.notify("Gravity OFF. Landed at " .. final_pos[1] .. ":" .. final_pos[2], vim.log.levels.INFO)
end

--- Main user-facing setup function.
function M.setup(user_config)
  Config = vim.tbl_deep_extend("force", Config, user_config or {})
  -- Create a dedicated namespace for our extmarks to avoid conflicts
  M.namespace_id = vim.api.nvim_create_namespace("grapplevim")
  vim.keymap.set("n", Config.map_leader, M.start, { desc = "Start Grapplevim" })
end

return M
