{ ... }:

{
  system.autoUpgrade = {
    enable = true;
    flake = "github:evaan/homelab#sotetseg";
    upgrade = false;
    operation = "switch";
    dates = "04:40";
    allowReboot = false;
    flags = [
      "--recreate-lock-file"
      "--no-write-lock-file"
    ];
  };
}
