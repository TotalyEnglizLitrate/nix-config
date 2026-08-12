{
  description = "NixOS configs for my machines";

  outputs = {self, ...} @ args: let
    inputs = (import ./.tack) {overrides = args.tackOverrides or {};};
    inherit (self) outputs;
    users = {
      engliz = {
        email = "narendra.s1232@gmail.com";
        fullName = "Narendra S";
        name = "engliz";
        signingKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtlDkVL/0TH2zsD+nSawpwChiXH9QYkDXXxtaNtji5g"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRbsrBxvy3bBKMzRZkYvbSld4PHlr6tDzipcy0On6XX"
        ];
      };

      user = {
        email = "123@abc.def";
        fullName = "User";
        name = "user";
        password = "changeme";
      };
    };

    mkNixosConfiguration = hostname: username: let
      hostProfile = ./hosts/${hostname}/profile.nix;
    in
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/${hostname}/configuration.nix
          ./hosts/common.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          {
            cfg = {
              user = users.${username};
              host = {inherit hostname;};
            };

            home-manager = {
              sharedModules = [
                ./hosts/common.nix
                ./modules/desktop/common/commands.nix
                inputs.mangowc.hmModules.mango
                hostProfile
                {
                  cfg = {
                    user = users.${username};
                    host = {inherit hostname;};
                  };
                }
              ];
              extraSpecialArgs = {inherit inputs outputs;};
              users.${username} = import ./home/${username}/${hostname}.nix;
            };
          }
        ];
      };

    mkHomeConfiguration = hostname: username: system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      hostProfile = ./hosts/${hostname}/profile.nix;
    in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/common.nix
          inputs.stylix.homeModules.stylix
          ./modules/stylix/host.nix
          ./modules/desktop/common/commands.nix
          inputs.mangowc.hmModules.mango
          hostProfile
          {
            cfg = {
              user = users.${username};
              host = {inherit hostname;};
            };
          }
          ./home/${username}/${hostname}.nix
        ];
      };
  in {
    nixosConfigurations = {
      latitude5491 = mkNixosConfiguration "latitude5491" "engliz";
      omnibook = mkNixosConfiguration "omnibook" "engliz";
      wanderer = mkNixosConfiguration "wanderer" "engliz";
      vm = mkNixosConfiguration "vm" "user";
    };

    overlays = import ./overlays.nix {inherit inputs;};

    inherit inputs;
  };
}
