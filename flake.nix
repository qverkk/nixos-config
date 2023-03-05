{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    hyprland.url = "github:hyprwm/Hyprland/v0.22.0beta";
    hyprwm-contrib.url = "github:hyprwm/contrib";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;

      pkgs = import nixpkgs {
        config = { allowUnfree = true; };
      };

      system = "x86_64-linux";

      lib = nixpkgs.lib;
    in
    {
      homeConfigurations = {
        qverkk = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/nixos.nix ];
        };
      };
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          modules = [
            ./hosts/nixos
          ];
        };
      };
    };
}
