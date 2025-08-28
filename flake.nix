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
      url = "github:0xc000022070/zen-browser-flake/d9c8ac0065e977a6776bed89909d82d58b297c65";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Runner
    walker.url = "github:abenz1267/walker";

    # NixOS profiles to optimize settings for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # Global catppuccin theme
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nyx = {
      url = "github:Peritia-System/Nyx-Tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    catppuccin,
    home-manager,
    nixpkgs,
    zen-browser,
    walker,
    stylix,
    niri,
    nyx,
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
          inherit inputs outputs hostname niri nyx;
          userConfig = users.${username};
        };
        modules = [
          ./hosts/${hostname}/configuration.nix
        ];
      };

    # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {
          inherit inputs outputs zen-browser walker hostname;
          userConfig = users.${username};
        };
        modules = [
          ./home/${username}/${hostname}.nix
          catppuccin.homeModules.catppuccin
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
