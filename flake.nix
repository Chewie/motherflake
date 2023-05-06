{
  description = "The master flake for Loutre Telecom";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    deploy-rs.url = github:serokell/deploy-rs;
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    dotfiles.url = github:Chewie/dotfiles;
    dotfiles.flake = false;
  };

  outputs = inputs@{ self, nixpkgs, deploy-rs, home-manager, dotfiles, ...  }: {
    nixosConfigurations = {
      axolotl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos_configurations/common/workstation.nix
          ./nixos_configurations/hosts/axolotl.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.chewie = import ./users/chewie.nix;
              extraSpecialArgs = { inherit dotfiles; };
            };
          }
        ];
      };
      squirrel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos_configurations/common/server.nix
          ./nixos_configurations/hosts/squirrel.nix
        ];
      };
    };
    deploy.nodes = {
      squirrel = {
        hostname = "squirrel.loutre.tel";
        profiles.system = {
          sshUser = "root";
          user = "root";
          sshOpts = [ "-p" "5122" ];
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.squirrel;
        };
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
