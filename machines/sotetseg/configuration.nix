{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/auto-upgrade.nix
    ../../modules/caddy-backends.nix
    ../../modules/containers.nix
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
    interfaces.enp3s0.ipv4.addresses = [
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

  nix.gc = {
    automatic = true;
    dates = "daily";
  };

  systemd.services.nix-gc.preStart = ''
    ${config.nix.package}/bin/nix-env \
      --profile /nix/var/nix/profiles/system \
      --delete-generations +3
  '';

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

  environment.systemPackages = [
    pkgs.intel-gpu-tools
    (pkgs.writeShellScriptBin "sotetseg" ''
      exec /run/wrappers/bin/sudo ${import ../../modules/rebuild-script.nix {
        inherit pkgs;
        hostName = "sotetseg";
      }}/bin/sotetseg-rebuild
    '')
  ];

  hardware = {
    graphics = {
      enable = true;
      extraPackages = [ pkgs.intel-media-driver ];
    };
  };

  boot.kernelModules = [ "i915" ];

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
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.05";
}
