{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../services/caddy
    ../../services/cloudflare-ddns
    ../../services/tailscale
  ];

  time.timeZone = "America/St_Johns";

  networking = {
    hostName = "cerberus";
    useDHCP = false;
    interfaces.enp2s0.ipv4.addresses = [
      {
        address = "192.168.7.4";
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
    extraGroups = [ "wheel" ];
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.evan = import ../../home/evan.nix;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    just
    vim
    (writeShellScriptBin "cerberus" ''
      exec /run/wrappers/bin/sudo ${import ../../modules/rebuild-script.nix {
        inherit pkgs;
        hostName = "cerberus";
      }}/bin/cerberus-rebuild
    '')
  ];

  swapDevices = [
    {
      device = "/.swapfile";
      size = 2048;
    }
  ];

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.05";
}
