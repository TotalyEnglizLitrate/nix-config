{pkgs, userConfig, ...}: {
  environment.systemPackages = with pkgs; [ termshark wireshark ];
  programs.wireshark = {
    enable = true;
    usbmon.enable = true;
  };
  users.users.${userConfig.name}.extraGroups = ["wireshark"];
}
