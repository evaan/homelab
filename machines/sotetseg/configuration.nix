{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/auto-upgrade.nix
    ../../modules/containers.nix
    ../../services/caddy
    ../../services/cloudflare-ddns
    ../../services/grafana
    ../../services/plex
    ../../services/tailscale
    ../../services/vaultwarden
    ../../services/vigil
  ];

  time.timeZone = "America/St_Johns";

  networking = {
    hostName = "sotetseg";
    useDHCP = false;
    interfaces.enp4s0.ipv4.addresses = [
      {
        address = "192.168.7.2";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.7.1";
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PubkeyAuthentication = true;
    };
  };

  users.users.evan = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLdFa8eo+/mlCGxDx5X5Mc6SneH9FNEYbB5GY+lExOa"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGs6/Pv151R2QI0gtw68SexvDEmy3KChDGq9efRs4Sgs"
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  virtualisation.docker.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = [ pkgs.intel-gpu-tools ];

  hardware = {
    graphics = {
      enable = true;
      extraPackages = [ pkgs.intel-media-driver ];
    };
    nvidia = {
      branch = "legacy_580";
      open = false;
      gsp.enable = false;
      nvidiaSettings = false;
    };
    nvidia-container-toolkit.enable = true;
  };

  boot.kernelModules = [
    "i915"
    "nvidia"
    "nvidia_uvm"
  ];

  fileSystems = {
    "/mnt/arceuus/Movies" = {
      device = "192.168.7.3:/mnt/arceuus/Data/Movies";
      fsType = "nfs";
      options = [
        "ro"
        "_netdev"
        "x-systemd.automount"
        "nofail"
      ];
    };
    "/mnt/arceuus/TV Shows" = {
      device = "192.168.7.3:/mnt/arceuus/Data/TV Shows";
      fsType = "nfs";
      options = [
        "ro"
        "_netdev"
        "x-systemd.automount"
        "nofail"
      ];
    };
    "/mnt/arceuus/4K Movies" = {
      device = "192.168.7.3:/mnt/arceuus/Data/4K Movies";
      fsType = "nfs";
      options = [
        "ro"
        "_netdev"
        "x-systemd.automount"
        "nofail"
      ];
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.evan = import ../../home/evan.nix;
  };

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.05";
}
