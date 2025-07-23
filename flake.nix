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
  };

  outputs = {
    self,
    catppuccin,
    home-manager,
    nixpkgs,
    zen-browser,
    walker,
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
        ];
      };

    # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {
          inherit inputs outputs zen-browser walker;
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
    };

    homeConfigurations = {
      "engliz@lattitude5491" = mkHomeConfiguration "x86_64-linux" "engliz" "lattitude5491";
      "engliz@ideapad320" = mkHomeConfiguration "x86_64-linux" "engliz" "ideapad320";
    };
    overlays = import ./overlays {inherit inputs;};

    # include wallpapers
    packages.x86_64-linux.wallpapers = nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {
      name = "wallpapers";
      src = builtins.path {
        path = ./files/wallpapers;
        name = "wallpapers-src";
        filter = path: type: true;
      };

      buildPhase = ''
        echo "=== DEBUG INFO ==="
        echo "Source directory: $src"
        echo "Current directory: $(pwd)"
        echo "Contents:"
        echo "File count: $(find . -type f | wc -l)"
        echo "=================="
      '';

      installPhase = ''
        mkdir -p $out/share/wallpapers

        # Copy everything, preserving structure
        cp -r . $out/share/wallpapers/

        # Remove any unwanted files
        find $out/share/wallpapers -name ".*" -delete

        echo "=== INSTALL DEBUG ==="
        echo "Final contents:"
        ls -la $out/share/wallpapers/
        echo "Final file count: $(find $out/share/wallpapers -type f | wc -l)"
        echo "===================="
      '';
    };
  };
}
