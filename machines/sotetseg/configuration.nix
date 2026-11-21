{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/containers.nix
    ../../services/plex
    ../../services/vaultwarden
    ../../services/vigil
  ];

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
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  virtualisation.docker.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;
    nvidia = {
      branch = "legacy_580";
      open = false;
      gsp.enable = false;
      nvidiaSettings = false;
    };
    nvidia-container-toolkit.enable = true;
  };

  boot.kernelModules = [
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

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.05";
}
