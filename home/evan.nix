{ pkgs, ... }:

{
  home = {
    username = "evan";
    homeDirectory = "/home/evan";
    stateVersion = "26.05";
    packages = with pkgs; [
      curl
      dnsutils
      fastfetch
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
