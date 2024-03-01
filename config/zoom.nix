{
  config.plugins = {
    telescope = {
      enable = true;
      keymaps = {
        "<leader>h" = "find_files";
        "<leader>pp" = "find_files";
        "<C-p>" = "git_files";
        "<leader>pg" = "git_files";
        "<leader>ps" = "live_grep";
        "<leader>pr" = "lsp_references";
        "<leader>pd" = "diagnostics";
        "<leader>ph" = "help_tags";
      };
    };

    leap = {
      enable = true;
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
}
