{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib?rev=33b38358559054d316eb605ccb733980dfa7dc63";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sg-nvim = {
    #   url = "github:sourcegraph/sg.nvim";
    # };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nur.url = "github:nix-community/NUR";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nur,
    ...
  } @ inputs: let
    inherit (self) outputs;

    system = "x86_64-linux";

    overlays = [
      (import ./overlays/rofi-wayland-unwrapped)
      (import ./overlays/leetcode-cli)
      (import ./overlays/google-java-format)
      (import ./overlays/nvim/supermaven)
      (import ./overlays/nvim/projections)
      (import ./overlays/nvim/typescript-tools)
      # (import ./overlays/nvim/codeium)
      (import ./overlays/nvim/codeiumnvim)
      (import ./overlays/nvim/focus)
      (import ./overlays/nvim/neotest-java)
      (import ./overlays/nvim/neotest-jdtls)
      (import ./overlays/nvim/neotest-vim-test)
      (import ./overlays/nvim/neotest-gradle)
      (import ./overlays/nvim/neotest)
      (import ./overlays/nvim/nvim-nio)
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
          {nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;}
        ];
      };

      "qverkk@hybrid" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs outputs pkgs;};
        modules = [
          ./home/hybrid.nix

          {home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";}
          {nix.registry.nixpkgs.flake = inputs.nixpkgs;}
          {nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;}
        ];
      };

      "qverkk@yogi" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs outputs pkgs;};
        modules = [
          ./home/yogi.nix

          {home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";}
          {nix.registry.nixpkgs.flake = inputs.nixpkgs;}
          {nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;}
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
          {nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;}
        ];
      };

      hybrid = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/hybrid

          {nix.nixPath = ["nixpkgs=flake:nixpkgs"];}
          {nix.registry.nixpkgs.flake = inputs.nixpkgs;}
          {nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;}
        ];
      };

      yogi = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/yogi

          {nix.nixPath = ["nixpkgs=flake:nixpkgs"];}
          {nix.registry.nixpkgs.flake = inputs.nixpkgs;}
          {nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;}
        ];
      };
    };
  };
}
