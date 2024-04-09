{pkgs, ...}: {
  imports = [
    ./options.nix
    ./lsp.nix
    ./zoom.nix
  ];

  plugins = {
    nvim-autopairs.enable = true;
    surround.enable = true;
    treesitter.enable = true;
    undotree.enable = true;
    comment.enable = true;
    vim-css-color.enable = true;

    oil.enable = true;
    neogit.enable = true;
    diffview.enable = true;
    gitsigns.enable = true;
    vimtex.enable = true;

    conform-nvim = {
      enable = true;
      formattersByFt = {
        lua = ["stylua"];
        nix = ["alejandra"];
        python = ["isort" "ruff_format"];
        "*" = ["trim_whitespace"];
      };
    };
    lint = {
      enable = true;
      lintersByFt = {
        python = ["ruff"];
      };
    };

    lualine = {
      enable = true;
      sections = {
        lualine_a = [{name = "mode";}];
        lualine_b = [{name = "branch";} {name = "diff";} {name = "diagnostics";}];
        lualine_c = [{name = "filename";}];
        lualine_x = [{name = "selectioncount";} {name = "filetype";}];
        lualine_y = [{name = "encoding";} {name = "fileformat";}];
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

  extraPlugins = with pkgs.vimPlugins; [
    vim-visual-multi
    vim-indent-object
  ];
}
