{lib}: {
  inherit (import ./user.nix {inherit lib;}) userType;
  inherit (import ./host.nix {inherit lib;}) hostType;
}
