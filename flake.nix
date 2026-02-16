{
  description = "flake for housey mousey servers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      apollo = lib.nixosSystem {
        inherit system;
        modules = [
          ./shared-config.nix
          ./hosts/apollo
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
