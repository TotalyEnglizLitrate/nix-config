{inputs, ...}: {
  imports = [inputs.noctalia-greetd.nixosModules.default];
  programs.noctalia-greeter.enable = true;
}
