{ config, pkgs, ... }: {
  imports = [
    ./../../system/sops.nix
    ./../../system/user.nix
    ./../../services/misc/vaultwarden.nix
    ./../../services/misc/watchtower.nix
    ./../../services/misc/homer.nix
    ./../../services/misc/adguard.nix
    ./../../services/misc/duckdns.nix
    ./../../services/misc/uptime.nix
    ./../../services/misc/caddy.nix
    ./../../services/misc/tailscale.nix
    ./../../services/misc/beszel-agent.nix
  ];

  system.stateVersion = "24.11";
  networking.hostName = "kephri";

  time.timeZone = "America/St_Johns";

  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.consoleLogLevel = 4; 

  fileSystems."/" = { 
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      trusted-users = [ "evan" ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking = {
    interfaces.enu1u1u1.ipv4.addresses = [{
      address = "192.168.2.8";
      prefixLength = 24;
    }];
    defaultGateway = {
      address = "192.168.2.1";
      interface = "enu1u1u1";
    };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  users.users.root.shell = pkgs.zsh;
  programs.zsh.enable = true;

  services.vscode-server.enable = true;

  virtualisation = {
    containers.enable = true;
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  networking.firewall.trustedInterfaces = [ "docker0" ];
}
