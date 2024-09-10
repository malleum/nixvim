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
nix run github:malleum/nixvim --experimental-features 'nix-command flakes'
```

## Running minimus vim
```
nix run github:malleum/nixvim#m --experimental-features 'nix-command flakes'
```
