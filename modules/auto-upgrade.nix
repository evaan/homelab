{ config, lib, pkgs, ... }:

{
  system.autoUpgrade = {
    enable = true;
    flake = "github:evaan/homelab#${config.networking.hostName}";
    upgrade = false;
    operation = "switch";
    dates = "04:40";
    allowReboot = false;
  };

  systemd.services.nixos-upgrade.script = lib.mkForce ''
    exec ${import ./rebuild-script.nix {
      inherit pkgs;
      hostName = config.networking.hostName;
    }}/bin/${config.networking.hostName}-rebuild
  '';
}
