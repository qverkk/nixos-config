{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib?rev=65e567a81176d39be7ce6513d1af23954f00cbec";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sg-nvim = {
    #   url = "github:sourcegraph/sg.nvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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
      (import ./overlays/nvim/typescript-tools)
      # (import ./overlays/nvim/codeium)
      (import ./overlays/nvim/codeiumnvim)
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
        modules = [
          ./home/nixos.nix

          {home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";}
          {nix.registry.nixpkgs.flake = inputs.nixpkgs;}
        ];
      };

      "qverkk@hybrid" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs outputs pkgs;};
        modules = [
          ./home/hybrid.nix

          {home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";}
          {nix.registry.nixpkgs.flake = inputs.nixpkgs;}
        ];
      };
    };
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nixos

          {nix.nixPath = ["nixpkgs=flake:nixpkgs"];}
          {nix.registry.nixpkgs.flake = inputs.nixpkgs;}
        ];
      };

      hybrid = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/hybrid

          {nix.nixPath = ["nixpkgs=flake:nixpkgs"];}
          {nix.registry.nixpkgs.flake = inputs.nixpkgs;}
        ];
      };
    };
  };
}
