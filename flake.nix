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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim = {
      url = "github:TotalyEnglizLitrate/nvim-nixcats";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant = {
      url = "github:TotalyEnglizLitrate/elephant/feat/playerctl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        elephant.follows = "elephant";
      };
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

  outputs = {
    self,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;

    users = {
      engliz = {
        email = "narendra.s1232@gmail.com";
        fullName = "Narendra S";
        name = "engliz";
      };
    };

    mkNixosConfiguration = hostname: username:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
        };
        modules = [
          ./hosts/${hostname}/configuration.nix
          inputs.niri.nixosModules.niri
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs outputs hostname;
                userConfig = users.${username};
              };
              users.${username} = import ./home/${username}/${hostname}.nix;
              sharedModules = [
                inputs.stylix.homeModules.stylix
                inputs.walker.homeManagerModules.default
              ];
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

    overlays = import ./overlays {inherit inputs;};
  };
}
