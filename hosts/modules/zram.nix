{...}: {
  zramSwap = {
    enable = true;
    swapDevices = 1;
    memoryPercent = 75;
  };
}
