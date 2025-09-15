{...}: {
  services.preload.enable = true;
  environment.etc."preload.conf".text = ''
    sortstrategy = 0
    minsize = 2000000;
     memtotal = 50;
  '';
}
