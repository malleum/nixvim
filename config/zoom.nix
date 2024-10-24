{
  plugins = {
    telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
      settings.defaults.layout_config.horizontal = {
        prompt_position = "top";
        width = 0.95;
        height = 0.85;
      };
      keymaps = {
        "<leader>h" = "find_files";
        "<leader>pg" = "git_files";
        "<leader>ps" = "live_grep";
        "<leader>pr" = "lsp_references";
        "<leader>pd" = "diagnostics";
        "<leader>ph" = "help_tags";
      };
    };

    harpoon = {
      enable = true;
      menu = {
        width = 100;
        height = 6;
      };
      keymaps = {
        addFile = "<leader>a";
        toggleQuickMenu = "<leader>o";
        navFile = {
          "1" = "<C-A-h>";
          "2" = "<C-A-t>";
          "3" = "<C-A-n>";
          "4" = "<C-A-s>";
        };
      };
    };
  };

  keymaps = [
    {
      mode = ["n"];
      key = "<leader>pt";
      action = "<cmd>TodoTelescope<cr>";
    }
    {
      mode = ["n"];
      key = "<leader>pS";
      action = "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input({ prompt = ' > ' }) })<cr>";
    }
    {
      mode = ["n"];
      key = "<leader>pw";
      action = "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') })<cr>";
    }
    {
      mode = ["n"];
      key = "<leader>pW";
      action = "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cWORD>') })<cr>";
    }
  ];
}
