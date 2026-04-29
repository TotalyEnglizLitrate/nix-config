{
  description = "NixOS configs for my machines";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium-browser = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim = {
      url = "github:TotalyEnglizLitrate/nvim-nixcats";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    inherit (self) outputs;
    users = {
      engliz = {
        email = "narendra.s1232@gmail.com";
        fullName = "Narendra S";
        name = "engliz";
      };
    };

    mkNixosConfiguration = hostname: username:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/${hostname}/configuration.nix
          ./modules/cfg
          inputs.home-manager.nixosModules.home-manager
          inputs.niri.nixosModules.niri
          inputs.nixos-cli.nixosModules.nixos-cli
          inputs.stylix.nixosModules.stylix
          {
            cfg = {
              user = users.${username};
              host = {inherit hostname;};
            };

            home-manager = {
              sharedModules = [./modules/cfg ./modules/cfg/commands.nix];
              extraSpecialArgs = {inherit inputs outputs;};
              users.${username} = import ./home/${username}/${hostname}.nix;
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      latitude5491 = mkNixosConfiguration "latitude5491" "engliz";
      omnibook = mkNixosConfiguration "omnibook" "engliz";
      wanderer = mkNixosConfiguration "wanderer" "engliz";
    };

    overlays = import ./overlays.nix {inherit inputs;};
  };
}
