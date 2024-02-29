{
  config.plugins = {
    lsp = {
      enable = true;
      servers = {
        lua-ls.enable = true;
        gopls.enable = true;
        html.enable = true;
        htmx.enable = true;
        jsonls.enable = true;
        kotlin-language-server.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        rnix-lsp.enable = true;
      };
    };
    luasnip = {
      enable = true;
    };
    nvim-cmp = {
      enable = true;
      autoEnableSources = true;
      sources = [
        {name = "nvim_lsp";}
        {name = "luasnip";}
        {name = "nvim_lua";}
        {name = "path";}
        {name = "buffer";}
      ];
      preselect = "Item";
      completion = {
        completeopt = "menu,menuone,noinsert";
      };
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = true })";
      };
    };
  };
}
