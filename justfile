sotetseg:
    sudo nixos-rebuild switch --flake .#sotetseg
buildEldric:
    nix run nixpkgs#nixos-generators -- -f sd-aarch64 --flake .#eldric --system aarch64-linux -o ./kephri.sd
eldric:
    nixos-rebuild switch --flake .#eldric --target-host evan@192.168.2.8 --use-remote-sudo