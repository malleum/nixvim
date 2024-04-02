{pkgs, ...}:  {
  imports = [
    ./options.nix
    ./lsp.nix
    ./zoom.nix
  ];

  config = {
    plugins = {
      nvim-autopairs.enable = true;
      lualine.enable = true;
      surround.enable = true;
      treesitter.enable = true;
      undotree.enable = true;
      comment.enable = true;
      conform-nvim = {
        enable = true;
        formattersByFt = {
          lua = ["stylua"];
          nix = ["alejandra"];
          python = ["isort" "ruff"];
          "*" = ["trim_whitespace"];
        };
      };
      lint = {
        enable = true;
        lintersByFt = {
          python = ["ruff"];
        };
      };
      oil.enable = true;
      fugitive.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      vim-visual-multi
      vim-indent-object
    ];
  };
}
