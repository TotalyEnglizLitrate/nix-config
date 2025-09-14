{
  description = "NixOS configs for my machines";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

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

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
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
        ];
      };

    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
        };
        modules = [
          ./home/${username}/${hostname}.nix
          inputs.stylix.homeModules.stylix
          inputs.walker.homeManagerModules.default
        ];
      };
  in {
    nixosConfigurations = {
      lattitude5491 = mkNixosConfiguration "lattitude5491" "engliz";
      omnibook = mkNixosConfiguration "omnibook" "engliz";
    };

    homeConfigurations = {
      "engliz@lattitude5491" = mkHomeConfiguration "x86_64-linux" "engliz" "lattitude5491";
      "engliz@omnibook" = mkHomeConfiguration "x86_64-linux" "engliz" "omnibook";
    };
    overlays = import ./overlays {inherit inputs;};
  };
}
