{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../system/sops.nix
    ./../../system/user.nix
    ./../../services/media
    ./../../services/misc/postgres.nix
    ./../../services/misc/redis.nix
    ./../../services/misc/syncthing.nix
    ./../../services/misc/restic.nix
    ./../../services/games/minecraft.nix
    ./../../services/games/tmodloader.nix
    ./../../services/misc/beszel/hub.nix
    ./../../services/misc/beszel/agent-nvidia.nix
    ./../../services/misc/watchtower.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "24.11";
  networking.hostName = "sotetseg";

  time.timeZone = "America/St_Johns";

  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.tailscale.enable = true;

  networking = {
    interfaces.enp4s0.ipv4.addresses = [{
      address = "192.168.7.2";
      prefixLength = 24;
    }];
    defaultGateway = {
      address = "192.168.7.1";
      interface = "enp4s0";
    };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  users.users.root.shell = pkgs.zsh;
  programs.zsh.enable = true;

  fileSystems."/mnt/storage" = {
    device = "192.168.7.3:/mnt/arceuus/Data";
    fsType = "nfs";
    options = [
      "nfsvers=3"
      "rw"
      "async"
      "rsize=65536"
      "wsize=65536"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=10"
      "noatime"
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.vscode-server.enable = true;

  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics.enable32Bit = true;

  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      enableNvidia = true;
      autoPrune.enable = true;
    };
    oci-containers.backend = "docker";
  };

  networking.firewall.trustedInterfaces = [ "docker0" ];
}
