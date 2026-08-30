_: {
  services.udev.extraRules = ''
    # URX Core75
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="3130", MODE:="0660", TAG+="uaccess"
    # URX Core75 2.4G
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="3002", MODE:="0660", TAG+="uaccess"
    # VIAL
    SUBSYSTEM=="usb", ATTRS{idVendor}=="*", MODE="0660", GROUP="input", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="*", MODE="0660", GROUP="input", TAG+="uaccess"
  '';
}
