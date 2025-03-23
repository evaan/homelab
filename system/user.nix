{ config, lib, pkgs, ... }: {
  users.users.evan = {
    isNormalUser = true;
    home = "/home/evan";
    shell = pkgs.zsh; 
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLdFa8eo+/mlCGxDx5X5Mc6SneH9FNEYbB5GY+lExOa"
    ];
    extraGroups = [ "docker" ];
  };

  networking.firewall.allowedTCPPorts = [ 5201 ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    
    users.evan = {
      home.packages = with pkgs; [
        neofetch
        git
        htop
        vim
        tmux
        just
        age
        sops
        unzip
        zip
        wget
        speedtest-cli
        iperf3
        dmidecode
        ethtool
        go
        gnumake
        ffmpeg
        cargo
        rustc
      ];

      home.stateVersion = "24.11";

      home.sessionVariables = {
        EDITOR = "vim";
      };

      home.file.".hushlogin".text = "";
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    promptInit = ''
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^H' backward-kill-word
      bindkey '^[[3;5~' kill-word
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word
      bindkey "^[[3;3~" delete-word
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
  };

  security.sudo.extraRules = [
    {
      users = [ "evan" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}