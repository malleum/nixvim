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
- [x] lsp issues
    - [x] <C-n>/<C-p> for lsp conmpletion
    - [x] lsp kemaps syntax update
    - [x] dart lsp
    - [x] hover border
    - [x] fix snippets
- [x] new plugins
    - [x] neogit
    - [x] latex
    - [x] flash
- [x] update configs
    - [x] telescope config
    - [x] lualine config
- [ ] seperate options into seperate config
