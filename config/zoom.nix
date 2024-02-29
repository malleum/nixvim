{
  config.plugins. telescope = {
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
}
