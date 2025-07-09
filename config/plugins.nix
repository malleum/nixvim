{
  pkgs,
  lib,
  config,
  ...
}: let
  alejandra = "${pkgs.alejandra}/bin/alejandra";
  cljfmt = "${pkgs.cljfmt}/bin/cljfmt";
  gdformat = "${pkgs.gdtoolkit_4}/bin/gdformat";
  gofmt = "${pkgs.go}/bin/gofmt";
  goimports = "${pkgs.goimports-reviser}/bin/goimports-reviser";
  isort = "${pkgs.isort}/bin/isort";
  prettierd = "${pkgs.prettierd}/bin/prettierd";
  ruff = "${pkgs.ruff}/bin/ruff";
  stylua = "${pkgs.stylua}/bin/stylua";
in {
  config = {
    plugins = {
      oil.enable = true;
      neogit.enable = true;
      comment.enable = true;
      diffview.enable = true;
      gitsigns.enable = true;
      nvim-autopairs.enable = true;
      nvim-surround.enable = true;
      todo-comments.enable = true;
      typst-preview.enable = true;
      web-devicons.enable = true;

      treesitter = lib.mkIf config.lsps.enable {
        enable = true;
        settings = {
          auto_install = true;
          ensure_installed = "all";
          highlight.enable = true;
          indent.enable = true;
        };
      };

      conform-nvim = lib.mkIf config.lsps.enable {
        enable = true;
        settings = {
          formatters = {
            alejandra.command = alejandra;
            cljfmt.command = cljfmt;
            gdformat.command = gdformat;
            gofmt.command = gofmt;
            goimports.command = goimports;
            isort.command = isort;
            prettierd.command = prettierd;
            ruff_format = {
              command = ruff;
              prepend_args = ["format"];
            };
            stylua.command = stylua;
          };
          formatters_by_ft = {
            "*" = ["trim_whitespace"];
            clojure = ["cljfmt"];
            gdscript = ["gdformat"];
            go = ["goimports" "gofmt"];
            javascript = ["prettierd"];
            lua = ["stylua"];
            nix = ["alejandra"];
            python = ["isort" "ruff_format"];
          };
        };
      };

      lint = {
        enable = true;
        linters.ruff.cmd = ruff;
        lintersByFt.python = ["ruff"];
      };

      lualine = {
        enable = true;
        settings = {
          options = {
            section_separators = {
              left = "";
              right = "";
            };
            component_separators = {
              left = "\\";
              right = "/";
            };
          };
          sections = {
            lualine_a = ["mode"];
            lualine_b = ["branch" "diff" "diagnostics"];
            lualine_c = ["filename"];
            lualine_x = ["selectioncount" "filetype"];
            lualine_y = ["encoding" "filexxformat"];
            lualine_z = ["location"];
          };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>g";
        action = "<cmd>Neogit<cr>";
      }
      {
        mode = "n";
        key = "<leader>ut";
        action = "<cmd>UndotreeToggle<cr>";
      }
    ];

    extraPlugins = with pkgs.vimPlugins; [
      vim-visual-multi
      vim-indent-object
      (pkgs.vimUtils.buildVimPlugin {
        name = "grapplevim";
        src = ../grapplevim;
      })
    ];
    extraConfigLua =
      # lua
      ''
        require('grapplevim').setup({map_leader = "<Backspace>"})
      '';
  };
}
