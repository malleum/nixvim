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
  options.vimtex.enable = lib.mkEnableOption "Enable latex plugin";

  config = {
    plugins = {
      ccc.enable = true;
      oil.enable = true;
      neogit.enable = true;
      comment.enable = true;
      diffview.enable = true;
      gitsigns.enable = true;
      surround.enable = true;
      undotree.enable = true;
      quickmath.enable = true;
      todo-comments.enable = true;
      nvim-autopairs.enable = true;
      markdown-preview.enable = true;
      vimtex.enable = config.vimtex.enable;

      treesitter = {
        enable = true;
        settings = {
          auto_install = true;
          highlight.enable = true;
        };
      };

      conform-nvim = {
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
        sectionSeparators = {
          left = "";
          right = "";
        };
        componentSeparators = {
          left = "\\";
          right = "/";
        };
        sections = {
          lualine_a = [{name = "mode";}];
          lualine_b = [{name = "branch";} {name = "diff";} {name = "diagnostics";}];
          lualine_c = [{name = "filename";}];
          lualine_x = [{name = "selectioncount";} {name = "filetype";}];
          lualine_y = [{name = "encoding";} {name = "filexxformat";}];
          lualine_z = [{name = "location";}];
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
      require('btw').setup({ text = "I use neovim (btw)" })
    '';

    extraPlugins = with pkgs.vimPlugins; [
      vim-visual-multi
      vim-indent-object
      (pkgs.vimUtils.buildVimPlugin {
        pname = "btw.nvim";
        version = "2024-04-36";
        src = pkgs.fetchFromGitHub {
          owner = "letieu";
          repo = "btw.nvim";
          rev = "47f6419e90d3383987fd06e8f3e06a4bc032ac83";
          hash = "sha256-91DZUfa4FBvXnkcNHdllr82Dr1Ie+MGVD3ibwkqo04c=";
        };
      })
    ];
  };
}
