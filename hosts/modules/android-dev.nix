{pkgs, userConfig, ...}: {
  users.users.${userConfig.name}.extraGroups = ["kvm" "adbusers"];
  environment.systemPackages = with pkgs; [ android-studio-full android-tools flutter ];
  nixpkgs.config.android_sdk.accept_license = true;
}
