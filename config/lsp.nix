{
  config.plugins = {
    fidget.enable = true;
    lsp = {
      enable = true;
      servers = {
        clangd.enable = true;
        dartls.enable = true;
        gopls.enable = true;
        html.enable = true;
        htmx.enable = true;
        jsonls.enable = true;
        kotlin-language-server.enable = true;
        lua-ls.enable = true;
        nixd.enable = true;
        pyright.enable = true;
      };
      keymaps = {
        diagnostic = {
          "[d" = "goto_next";
          "]d" = "goto_prev";
          "gl" = "open_float";
        };
        lspBuf = {
          "K" = "hover";
          "gd" = "definition";
          "gD" = "declaration";
          "gi" = "implementation";
          "go" = "type_definition";
          "gr" = "references";
          "gs" = "signature_help";

          "<leader>rn" = "rename";
          "<leader>ra" = "code_action";
          "<leader>rr" = "references";
        };
      };
      onAttach = ''
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
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "nvim_lua";}
          {name = "path";}
          {name = "buffer";}
        ];
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        };
      };
    };
  };
}
