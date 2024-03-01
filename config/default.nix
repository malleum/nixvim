{
  imports = [
    ./options.nix
    ./lsp.nix
    ./zoom.nix
  ];

  config = {
    plugins = {
      lualine.enable = true;
      surround.enable = true;
      treesitter.enable = true;
      undotree.enable = true;
      comment-nvim.enable = true;
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
    };
  };
}
