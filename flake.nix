{
  description = "Evan's Homelab Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = { self, nixpkgs, home-manager, vscode-server, sops-nix, nix-minecraft, ... }@inputs: rec {
    nixosConfigurations.sotetseg = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      system = "x86_64-linux";
      modules = [
        ./machines/sotetseg/configuration.nix

        home-manager.nixosModules.home-manager
        vscode-server.nixosModules.default
        sops-nix.nixosModules.sops
      ];
    };
    nixosConfigurations.eldric = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./machines/eldric/configuration.nix

        home-manager.nixosModules.home-manager
        vscode-server.nixosModules.default
        sops-nix.nixosModules.sops
      ];
    };
  };
}
