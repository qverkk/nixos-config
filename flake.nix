{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    hyprland.url = "github:hyprwm/Hyprland/v0.22.0beta";
  };

  outputs = { nixpkgs, home-manager, ... }: 
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;
  in {
    homeManagerConfigurations = {
      qverkk = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
	username = "qverkk";
	homeDirectory = "/home/qverkk";
	configuration = {
          imports = [
            
	  ];
	};
      };
    };
    nixosConfigurations = {
      nixos = lib.nixosSystem {
	inherit system;
	modules = [ ./hosts/nixos ];
      };
    };
  };
}
