{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib?rev=1af47a008e850c595aeddc83bb3f04fd81935caa";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    hyprland.url = "github:hyprwm/Hyprland/v0.23.0beta";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";

      overlays = [
        (import ./overlays/flameshot)
      ];

      pkgs = import nixpkgs {
        inherit system;
        inherit overlays;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;
    in
    {
      devShells.${system} = {
        #run by `nix devlop` or `nix-shell`(legacy)
        default = import ./shell.nix { inherit pkgs; };
      };

      homeConfigurations = {
        qverkk = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs outputs pkgs; };
          modules = [ ./home/nixos.nix ];
        };
      };
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixos
          ];
        };
      };
    };
}
