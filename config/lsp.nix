{
  config.plugins = {
    fidget.enable = true;
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
      onAttach = ''
        vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
        vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
        vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end)
        vim.keymap.set("n", "<leader>ra", function() vim.lsp.buf.code_action() end)
        vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end)
        vim.keymap.set("n", "<leader>f", function() require("conform").format({ async = true, lsp_fallback = true }) end)
      '';
    };
    luasnip = {
      enable = true;
      extraConfig = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
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
