{...}: {
  services.tuned = {
    enable = true;
    ppdSupport = false;
    settings = {
      update_interval = 5;
      dynamic_tuning = true;
    };
  };
}
