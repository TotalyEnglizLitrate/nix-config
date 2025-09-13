{
  description = "NixOS configs for my machines";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # themeing
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
    # Runner
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS profiles to optimize settings for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # NixOS Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Define user configurations
    users = {
      engliz = {
        email = "narendra.s1232@gmail.com";
        fullName = "Narendra S";
        name = "engliz";
      };
    };

    # Function for NixOS system configuration
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

    # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
        };
        modules = [
          ./home/${username}/${hostname}.nix
          stylix.homeModules.stylix
        ];
      };
  in {
    nixosConfigurations = {
      lattitude5491 = mkNixosConfiguration "lattitude5491" "engliz";
      ideapad330 = mkNixosConfiguration "ideapad330" "engliz";
      omnibook = mkNixosConfiguration "omnibook" "engliz";
    };

    homeConfigurations = {
      "engliz@lattitude5491" = mkHomeConfiguration "x86_64-linux" "engliz" "lattitude5491";
      "engliz@ideapad320" = mkHomeConfiguration "x86_64-linux" "engliz" "ideapad320";
      "engliz@omnibook" = mkHomeConfiguration "x86_64-linux" "engliz" "omnibook";
    };
    overlays = import ./overlays {inherit inputs;};
  };
}
