{
  inputs,
  outputs,
  users,
}: {
  mkNixosConfiguration = hostname: username:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs hostname;
        userConfig = users.${username};
      };
      modules = [
        ./hosts/${hostname}/configuration.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.niri.nixosModules.niri
        inputs.nixos-cli.nixosModules.nixos-cli
        inputs.stylix.nixosModules.stylix
        {
          home-manager = {
            extraSpecialArgs = {
              inherit inputs outputs hostname;
              userConfig = users.${username};
            };
            users.${username} = import ./home/${username}/${hostname}.nix;
          };
        }
      ];
    };
}
