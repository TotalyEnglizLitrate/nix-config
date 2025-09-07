{...}: {
  services.tuned = {
    enable = true;
    settings = {
      update_interval = 5;
      dynamic_tuning = true;
    };
  };
}
