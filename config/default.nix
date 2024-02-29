{
  config = {
    options = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers

      shiftwidth = 2; # Tab width should be 2
    };

    colorschemes.tokyonight = {
      enable = true;
      style = "night";
    };
    globals.mapleader = " ";
    plugins = {
      lualine.enable = true;
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
      nvim-cmp = {
        enable = true;
        autoEnableSources = true;
        sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
          {name = "luasnip";}
        ];

        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = {
            action = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expandable() then
                  luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif check_backspace() then
                  fallback()
                else
                  fallback()
                end
              end
            '';
            modes = ["i" "s"];
          };
        };
      };
    };
  };
}
