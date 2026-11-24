_: {
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # host aliases (e.g. `ssh oracle`) from agenix; silently skipped when absent
    includes = ["/run/agenix/oracle-ssh"];
    settings."*" = {
      addKeysToAgent = "yes";
      identityFile = "~/.ssh/git";
    };
  };
}
