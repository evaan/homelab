{ pkgs, ... }:

{
  home = {
    username = "evan";
    homeDirectory = "/home/evan";
    stateVersion = "26.05";
    file.".hushlogin".text = "";
    packages = with pkgs; [
      curl
      dnsutils
      fd
      git
      htop
      iproute2
      iputils
      jq
      just
      lsof
      ncdu
      netcat-openbsd
      nettools
      ripgrep
      tmux
      traceroute
      unzip
      wget
    ];
  };

  programs.home-manager.enable = true;

  programs.fastfetch = {
    enable = true;
    settings.modules = [
      "title"
      "separator"
      "os"
      "host"
      "kernel"
      "uptime"
      "packages"
      "shell"
      "display"
      "de"
      "wm"
      "wmtheme"
      "theme"
      "icons"
      "font"
      "cursor"
      "cpu"
      "gpu"
      "memory"
      "swap"
      "disk"
      {
        type = "disk";
        folders = "/mnt/arceuus/Movies";
        key = "Disk (arceuus)";
      }
      "localip"
      "battery"
      "poweradapter"
      "break"
      "colors"
    ];
  };

  programs.dircolors = {
    enable = true;
    settings = {
      OTHER_WRITABLE = "01;36";
      STICKY_OTHER_WRITABLE = "01;36";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases.neofetch = "fastfetch";
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    initContent = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };
}
