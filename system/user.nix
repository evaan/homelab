{ config, lib, pkgs, ... }: {
  users.users.evan = {
    isNormalUser = true;
    home = "/home/evan";
    shell = pkgs.zsh; 
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLdFa8eo+/mlCGxDx5X5Mc6SneH9FNEYbB5GY+lExOa"
    ];
    extraGroups = [ "podman" ];
  };

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
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$character";
      right_format = "$cmd_duration$username$hostname"; # TODO: Add git integration
      character.success_symbol = "[❯](bold blue)";
      directory.style = "bold purple";
      cmd_duration.format = "[$duration]($style) ";
      username = {
        style_root = "fg:160";
        style_user = "fg:242";
        show_always = true;
        format = "[$user]($style)";
      };
      hostname = {
        ssh_only = false;
        style = "fg:242";
        format = "[@$hostname]($style)";
      };
    };
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