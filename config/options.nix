{
  config = {
    options = {
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
  };
}
