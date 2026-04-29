{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    termshark
    wireshark
  ];
  programs.wireshark = {
    enable = true;
    usbmon.enable = true;
  };
  users.users.${config.cfg.user.name}.extraGroups = ["wireshark"];
}
