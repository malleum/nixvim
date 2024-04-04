{
  opts = {
    autoindent = true;
    autoread = true;
    autowrite = true;
    backup = false;
    cmdheight = 1;
    completeopt = ["menuone" "noselect" "noinsert"];
    cursorcolumn = true;
    cursorline = true;
    encoding = "utf-8";
    expandtab = true;
    hidden = true;
    history = 50;
    hlsearch = false;
    ignorecase = true;
    incsearch = true;
    mouse = "";
    nu = true;
    relativenumber = true;
    ruler = false;
    scrolloff = 7;
    shiftwidth = 4;
    showmode = false;
    signcolumn = "yes";
    smartcase = true;
    smarttab = true;
    softtabstop = 4;
    swapfile = false;
    tabstop = 4;
    termguicolors = true;
    undofile = true;
    updatetime = 50;
    wildmenu = true;
    wrap = false;
    writebackup = false;
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
}
