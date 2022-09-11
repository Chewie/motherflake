{
  description = "The master flake for Loutre Telecom";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    dotfiles.url = github:Chewie/dotfiles;
    dotfiles.flake = false;
  };

  outputs = inputs@{ nixpkgs, home-manager, dotfiles, ...  }: {
    nixosConfigurations.axolotl = nixpkgs.lib.nixosSystem {
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
  };
}
