{
  description = "A unified interface for AI in your terminal.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    toad = {
      url = "github:batrachianai/toad";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      pyproject-nix,
      uv2nix,
      toad,
      pyproject-build-systems,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;



      toadWithLock = pkgs.runCommand "toad-with-lock" {} ''
        mkdir -p $out
        cp -r ${toad}/. $out/
        chmod -R +w $out
        cp ${./uv.lock} $out/uv.lock
      '';

      workspace = uv2nix.lib.workspace.loadWorkspace {
        workspaceRoot = toadWithLock;
      };

      overlay = workspace.mkPyprojectOverlay {
        sourcePreference = "wheel";
      };

      pythonSets = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          python = pkgs.python314;
        in
        (pkgs.callPackage pyproject-nix.build.packages {
          inherit python;
        }).overrideScope
          (
            lib.composeManyExtensions [
              pyproject-build-systems.overlays.wheel
              overlay
            ]
          )
      );

    in
    {
      packages = forAllSystems (system: {
        default = pkgs.runCommand "toad" {} ''
          mkdir -p $out/bin
          ln -s ${pythonSets.${system}.mkVirtualEnv "toad" workspace.deps.default}/bin/toad $out/bin/toad
        '';
      });


      apps = forAllSystems (system: {
        update-lock = {
          type = "app";
          program = lib.getExe (pkgs.writeShellApplication {
          name = "update-lock";
          runtimeInputs = with pkgs; [ nix uv git python314 ];
          text = ''
            REPO_ROOT=$(git rev-parse --show-toplevel)/pkgs/toad
            TOAD_SRC=$(nix eval --raw --impure --expr "
              let lock = builtins.fromJSON (builtins.readFile \"$REPO_ROOT/flake.lock\");
                node = lock.nodes.toad.locked;
              in builtins.fetchTree node
            ")
            WORK=$(mktemp -d)
            cp -r "$TOAD_SRC/." "$WORK/"
            chmod -R +w "$WORK"
            cd "$WORK"
            uv lock --python ${pkgs.python314}/bin/python --cache-dir "$(mktemp -d)"
            cp uv.lock "$REPO_ROOT/uv.lock"
            echo "Done — commit flake.lock + uv.lock together"
          '';
        });
      };
    });
  };
}
