{
  config = {
    opts = {
      autoindent = true;
      expandtab = true;
      shiftwidth = 4;
      smarttab = true;
      softtabstop = 4;
      tabstop = 4;
      mouse = "";
      autoread = true;
      autowrite = true;
      cursorcolumn = true;
      cursorline = true;
      encoding = "utf-8";
      history = 50;
      ignorecase = true;
      incsearch = true;
      hlsearch = false;
      ruler = false;
      showmode = false;
      wrap = false;
      nu = true;
      relativenumber = true;
      scrolloff = 7;
      smartcase = true;
      wildmenu = true;
      signcolumn = "yes";
      cmdheight = 1;
      termguicolors = true;
      hidden = true;
      updatetime = 50;
      backup = false;
      writebackup = false;
      swapfile = false;
      undofile = true;
    };

    colorschemes.tokyonight = {
      enable = true;
      style = "night";
      transparent = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      loaded_netrw = 1;
      loaded_netrwPlugin = 1;
    };

    keymaps = [
      {
        mode = ["n"];
        key = "<Space>";
        action = "<Nop>";
        options.silent = true;
      }
      {
        mode = ["n" "v"];
        key = "<leader>Y";
        action = "\"+y$";
      }
      {
        mode = ["n" "v"];
        key = "<leader>y";
        action = "\"+y";
      }
      {
        mode = ["n" "v"];
        key = "<leader>D";
        action = "\"_D";
      }
      {
        mode = ["n" "v"];
        key = "<leader>d";
        action = "\"_d";
      }
      {
        mode = ["x"];
        key = "<leader>p";
        action = "\"_dP";
      }
      {
        mode = ["n"];
        key = "N";
        action = "Nzz";
      }
      {
        mode = ["n"];
        key = "n";
        action = "nzz";
      }
      {
        mode = ["n"];
        key = "<C-u>";
        action = "<C-u>zz";
      }
      {
        mode = ["n"];
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        mode = ["n"];
        key = "J";
        action = "mzJ1`z";
      }
      {
        mode = ["v"];
        key = "K";
        action = ":m '<-2<CR>gv=gv";
      }
      {
        mode = ["v"];
        key = "J";
        action = ":m '>+1<CR>gv=gv";
      }
      {
        mode = ["n"];
        key = "<leader>F";
        action = "mzgg=G`z";
      }
      {
        mode = ["n"];
        key = "Y";
        action = "y$";
      }
      {
        mode = ["c"];
        key = "W";
        action = "w";
      }
      {
        mode = ["n"];
        key = "-";
        action = ":Oil<cr>";
      }
    ];
  };
}
