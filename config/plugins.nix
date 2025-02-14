{
  pkgs,
  lib,
  config,
  ...
}: let
  ruff = "${pkgs.ruff}/bin/ruff";
  stylua = "${pkgs.stylua}/bin/stylua";
  alejandra = "${pkgs.alejandra}/bin/alejandra";
  isort = "${pkgs.isort}/bin/isort";
in {
  config = {
    plugins = {
      oil.enable = true;
      neogit.enable = true;
      comment.enable = true;
      diffview.enable = true;
      gitsigns.enable = true;
      web-devicons.enable = true;
      nvim-surround.enable = true;
      todo-comments.enable = true;
      nvim-autopairs.enable = true;

      treesitter = lib.mkIf config.lsps.enable {
        enable = true;
        settings = {
          auto_install = true;
          highlight.enable = true;
        };
      };

      conform-nvim = lib.mkIf config.lsps.enable {
        enable = true;
        settings = {
          formatters = {
            ruff_format = {
              command = ruff;
              prepend_args = ["format"];
            };
            stylua.command = stylua;
            alejandra.command = alejandra;
            isort.command = isort;
          };
          formatters_by_ft = {
            lua = ["stylua"];
            nix = ["alejandra"];
            python = ["isort" "ruff_format"];
            "*" = ["trim_whitespace"];
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

    extraConfigLua = ''
      require("typst-preview").setup()
    '';

    extraPlugins = with pkgs.vimPlugins; [
      vim-visual-multi
      vim-indent-object
      typst-preview-nvim
    ];
  };
}
