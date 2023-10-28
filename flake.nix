{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib?rev=805bedf51a2f75a2279b6fc75b3066ff21f235ee";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nur.url = "github:nix-community/NUR";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nur,
    ...
  } @ inputs: let
    inherit (self) outputs;

    system = "x86_64-linux";

    overlays = [
      (import ./overlays/rofi-wayland-unwrapped)
      (import ./overlays/leetcode-cli)
      (import ./overlays/nvim/projections)
      (import ./overlays/nvim/codeium)
      (import ./overlays/nvim/focus)
      (import ./overlays/nvim/flash)
      # (import ./overlays/nvim/coq-thirdparty)
      (import ./overlays {})
      inputs.nur.overlay
    ];

    pkgs = import nixpkgs {
      inherit system;
      inherit overlays;
      config.allowUnfree = true;
    };

    inherit (nixpkgs) lib;
  in {
    devShells.${system} = {
      #run by `nix devlop` or `nix-shell`(legacy)
      default = import ./shell.nix {inherit pkgs;};
    };

    homeConfigurations = {
      "qverkk@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs outputs pkgs;};
        modules = [./home/nixos.nix];
      };

      "qverkk@hybrid" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs outputs pkgs;};
        modules = [./home/hybrid.nix];
      };
    };
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nixos
        ];
      };

      hybrid = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/hybrid
        ];
      };
    };
  };
}
