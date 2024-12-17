{
  description = "malleus nixvim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = {
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = {
        pkgs,
        system,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = import ./config/default.nix {omnis = true;};
        };
        minimus = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = import ./config/default.nix {omnis = true;};
        };
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "malleus nixvim config";
          };
          # Run `nix flake check m` to verify that your config is not broken
          m = nixvimLib.check.mkTestDerivationFromNvim {
            m = minimus;
            name = "malleus minimus nixvim config";
          };
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
          # Lets you run `nix run m` to start nixvim
          m = minimus;
        };
      };
    };
}
