{
  imports = [
    ./options.nix
    ./lsp.nix
    ./zoom.nix
  ];

  config = {
    plugins = {
      lualine.enable = true;
    };
  };
}
