{...}: {
  # Install cliphist via home-manager module
  services.cliphist = {
    enable = true;
    systemdTargets = "river-session.target";
  };
}
