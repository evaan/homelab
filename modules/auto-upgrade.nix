{ lib, pkgs, ... }:

{
  system.autoUpgrade = {
    enable = true;
    flake = "github:evaan/homelab#sotetseg";
    upgrade = false;
    operation = "switch";
    dates = "04:40";
    allowReboot = false;
  };

  systemd.services.nixos-upgrade.script = lib.mkForce ''
    exec ${import ./rebuild-script.nix { inherit pkgs; }}/bin/sotetseg-rebuild
  '';
}
