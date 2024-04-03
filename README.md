# Nixvim Malleus Edition

## Testing your new configuration

To test your configuration simply run the following command
```
nix flake check .
```

## Running Locally
```
nix run .
```

## Running
```
nix run github:speedster33/nixvim --experimental-features 'nix-command flakes'
```

#### TODO
- [ ] lsp issues
    - [x] <C-n>/<C-p> for lsp conmpletion
    - [x] lsp kemaps syntax update
    - [x] dart lsp
    - [ ] hover border
    - [ ] fix snippets
- [ ] new plugins
    - [x] neogit
    - [x] latex
- [ ] update configs
    - [ ] leap remove x
    - [ ] telescope config
    - [ ] lualine config
- [ ] seperate options into seperate config
