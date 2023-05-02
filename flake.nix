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
    hyprland.url = "github:hyprwm/Hyprland/v0.24.1";

    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, nur, ... }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";

      overlays = [
        #        (import ./overlays/flameshot)
        (import ./overlays/rofi-wayland-unwrapped)
        (import ./overlays/nvim/projections)
        (import ./overlays { })
        inputs.nur.overlay
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
        "qverkk@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs outputs pkgs; };
          modules = [ ./home/nixos.nix ];
        };

        "qverkk@hybrid" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs outputs pkgs; };
          modules = [ ./home/hybrid.nix ];
        };
      };
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixos
          ];
        };

        hybrid = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/hybrid
          ];
        };
      };
    };
}
