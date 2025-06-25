-- grapplevim: A gravity and grappling hook plugin for Neovim
-- Author: You! (and Gemini)
-- Date: June 25, 2025 (State-Driven Refactor)

local M = {}

-- ====================================================================
-- 1. State and Configuration
-- ====================================================================

local State = {
	is_active = false,
	timer = nil,
	bufnr = 0,
	winid = 0,
	original_virtualedit = "",
	maps_set = {},

	pos = { x = 0.0, y = 0.0 },
	vel = { x = 0.0, y = 0.0 },

	grapple = {
		active = false,
		anchor = { x = 0, y = 0 },
		rope_length = 0,
		extmark_id = nil,
	},

	-- NEW: State-driven input table to track which keys are currently "held down"
	input = {
		j = false,
		k = false,
		h = false,
		l = false,
		space = false,
		-- Timers to simulate keyup events
		timers = {},
	},
}

local Config = {
	step_rate = 30,
	key_release_timeout = 50, -- How long after a key stops repeating to consider it "released" (in ms)
	gravity = 0.1,
	grapple_tension = 0.03,
	grapple_friction = 0.98,
	-- These are now "forces" applied on each tick a key is held down
	j_force = 0.4,
	k_force = 0.45, -- Slightly stronger to counteract gravity
	hl_force = 0.3,
	-- CHANGED: Visuals now use virt_text overlay instead of a sign
	anchor_overlay_text = "⚓",
	anchor_highlight = "WarningMsg",
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

--- Shows the grapple anchor visual by creating an extmark with an overlay.
local function show_grapple_anchor()
	hide_grapple_anchor()
	if State.grapple.anchor then
		-- CHANGED: Using virt_text with 'overlay' to place the anchor on top of the character
		State.grapple.extmark_id = vim.api.nvim_buf_set_extmark(
			State.bufnr,
			M.namespace_id,
			State.grapple.anchor.y - 1,
			State.grapple.anchor.x - 1,
			{
				virt_text = { { Config.anchor_overlay_text, Config.anchor_highlight } },
				virt_text_pos = "overlay",
			}
		)
	end
end

local function find_nearest_anchor()
	-- (This function remains unchanged)
	local start_pos = vim.api.nvim_win_get_cursor(0)
	local start_line, start_col = start_pos[1], start_pos[2]
	local max_lines = vim.api.nvim_buf_line_count(0)
	local best_dist_sq = math.huge
	local best_pos = nil
	for i = 0, max_lines do
		for _, sign in ipairs({ 1, -1 }) do
			local line_idx = start_line + (i * sign)
			if line_idx >= 1 and line_idx <= max_lines then
				local line_content = vim.api.nvim_buf_get_lines(0, line_idx - 1, line_idx, false)[1] or ""
				local first, last = line_content:find("%S"), line_content:find("%S.*$")
				if first then
					local closest_col
					if start_col < first then
						closest_col = first
					elseif start_col > last then
						closest_col = last
					else
						closest_col = start_col
					end
					local dist_sq = (line_idx - start_line) ^ 2 + (closest_col - start_col) ^ 2
					if dist_sq > 0 and dist_sq < best_dist_sq then
						best_dist_sq = dist_sq
						best_pos = { y = line_idx, x = closest_col }
					end
				end
			end
		end
		if best_pos and i > math.sqrt(best_dist_sq) then
			return best_pos
		end
	end
	return best_pos
end

--- NEW: Process the input state on each physics tick
local function process_input()
	if State.input.j then
		State.vel.y = State.vel.y + Config.j_force
	end
	if State.input.k then
		State.vel.y = State.vel.y - Config.k_force
	end
	if State.input.l then
		State.vel.x = State.vel.x + Config.hl_force
	end
	if State.input.h then
		State.vel.x = State.vel.x - Config.hl_force
	end

	-- Grapple logic is now based on the hold state of the space bar
	if State.input.space and not State.grapple.active then
		-- Engage grapple
		local anchor_pos = find_nearest_anchor()
		if anchor_pos then
			State.grapple.active = true
			State.grapple.anchor = anchor_pos
			local dx = State.grapple.anchor.x - State.pos.x
			local dy = State.grapple.anchor.y - State.pos.y
			State.grapple.rope_length = math.sqrt(dx * dx + dy * dy)
			show_grapple_anchor()
		end
	elseif not State.input.space and State.grapple.active then
		-- Release grapple
		State.grapple.active = false
		hide_grapple_anchor()
	end
end

-- MOVED: These functions are now defined *before* update() to fix the scope issue.
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

	-- 1. Process player input to determine forces
	process_input()

	-- 2. Apply environmental physics (This will now work correctly)
	apply_gravity()
	if State.grapple.active then
		apply_grapple_physics()
	end

	-- 3. Update position based on final velocity
	State.pos.x = State.pos.x + State.vel.x
	State.pos.y = State.pos.y + State.vel.y

	-- Boundary checks and cursor setting
	local max_lines = vim.api.nvim_buf_line_count(State.bufnr)
	if State.pos.y > max_lines then
		State.pos.y = max_lines
		State.vel.y = 0
	end
	if State.pos.y < 1 then
		State.pos.y = 1
		State.vel.y = 0
	end
	local win_width = vim.api.nvim_win_get_width(State.winid)
	if State.pos.x > win_width - 1 then
		State.pos.x = win_width - 1
		State.vel.x = -State.vel.x * 0.5
	end
	if State.pos.x < 0 then
		State.pos.x = 0
		State.vel.x = -State.vel.x * 0.5
	end
	vim.api.nvim_win_set_cursor(State.winid, { math.floor(State.pos.y), math.floor(State.pos.x) })
end

-- (apply_gravity and apply_grapple_physics functions are unchanged)
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

-- ====================================================================
-- 3. State Management and Keymaps (Heavily Refactored)
-- ====================================================================

--- NEW: Simulates a key being released after a timeout.
local function handle_keyup(key)
	State.input[key] = false
	State.input.timers[key] = nil
end

--- NEW: Simulates a key being pressed and held.
local function handle_keydown(key)
	State.input[key] = true
	-- If a release timer for this key already exists, stop it.
	if State.input.timers[key] then
		vim.fn.timer_stop(State.input.timers[key])
	end
	-- Start a new timer that will fire ONCE to signal a "keyup" if we don't get another keydown event.
	State.input.timers[key] = vim.fn.timer_start(Config.key_release_timeout, function()
		handle_keyup(key)
	end)
end

local function set_map(mode, key, key_name, desc)
	local map_opts = { buffer = State.bufnr, nowait = true, desc = "[Grapple] " .. desc }
	-- All movement keys now call handle_keydown
	vim.keymap.set(mode, key, function()
		handle_keydown(key_name)
	end, map_opts)
	if not State.maps_set[mode] then
		State.maps_set[mode] = {}
	end
	table.insert(State.maps_set[mode], key)
end

local function setup_gravity_maps()
	State.maps_set = {}
	-- Set special maps for stopping
	local stop_opts = { buffer = State.bufnr, nowait = true, desc = "[Grapple] Stop Gravity" }
	vim.keymap.set("n", Config.map_leader, M.stop, stop_opts)
	vim.keymap.set("n", "<Esc>", M.stop, stop_opts)
	table.insert(State.maps_set, { "n", Config.map_leader })
	table.insert(State.maps_set, { "n", "<Esc>" })

	-- Set state-driven maps
	set_map("n", "j", "j", "Hold Down")
	set_map("n", "k", "k", "Hold Up")
	set_map("n", "h", "h", "Hold Left")
	set_map("n", "l", "l", "Hold Right")
	set_map("n", Config.map_grapple, "space", "Hold Grapple")
end

local function clear_gravity_maps()
	for _, map_info in ipairs(State.maps_set) do
		pcall(vim.keymap.del, map_info[1], map_info[2], { buffer = State.bufnr })
	end
	State.maps_set = {}
end

--- Stops all input timers to prevent them from firing after exiting.
local function stop_input_timers()
	for key, timer_id in pairs(State.input.timers) do
		if timer_id then
			vim.fn.timer_stop(timer_id)
		end
		State.input[key] = false -- Reset state
	end
	State.input.timers = {}
end

--- Starts the gravity simulation.
function M.start()
	if State.is_active then
		return
	end
	State.is_active = true
	State.winid = vim.api.nvim_get_current_win()
	State.bufnr = vim.api.nvim_get_current_buf()
	State.original_virtualedit = vim.o.virtualedit
	vim.o.virtualedit = "all"
	local cursor_pos = vim.api.nvim_win_get_cursor(State.winid)
	State.pos = { y = cursor_pos[1], x = cursor_pos[2] }
	State.vel = { x = 0, y = 0 }
	State.grapple.active = false
	setup_gravity_maps()
	State.timer = vim.fn.timer_start(Config.step_rate, update, { ["repeat"] = -1 })
	vim.notify("Gravity ON", vim.log.levels.INFO)
	vim.wo[State.winid].cursorline = true
end

--- Stops the gravity simulation.
function M.stop()
	if not State.is_active then
		return
	end
	if State.timer then
		vim.fn.timer_stop(State.timer)
		State.timer = nil
	end
	stop_input_timers() -- NEW: Stop all pending key-release timers
	vim.o.virtualedit = State.original_virtualedit
	vim.wo[State.winid].cursorline = false
	hide_grapple_anchor()
	clear_gravity_maps()
	local final_pos = vim.api.nvim_win_get_cursor(State.winid)
	vim.cmd.stopinsert()
	vim.fn.col(".")
	State.is_active = false
	vim.notify("Gravity OFF. Landed at " .. final_pos[1] .. ":" .. final_pos[2], vim.log.levels.INFO)
end

--- Main user-facing setup function.
function M.setup(user_config)
	Config = vim.tbl_deep_extend("force", Config, user_config or {})
	M.namespace_id = vim.api.nvim_create_namespace("grapplevim")
	vim.keymap.set("n", Config.map_leader, M.start, { desc = "Start Grapplevim" })
end

return M
