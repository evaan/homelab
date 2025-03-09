sotetseg:
    sudo nixos-rebuild switch --flake .#sotetseg
buildEldric:
    nix run nixpkgs#nixos-generators -- -f sd-aarch64 --flake .#eldric --system aarch64-linux -o ./eldric.sd
eldric:
    nixos-rebuild switch --flake .#eldric --target-host evan@192.168.2.8 --use-remote-sudo
buildBranda:
    nix run nixpkgs#nixos-generators -- -f sd-aarch64 --flake .#branda --system aarch64-linux -o ./branda.sd
branda:
    nixos-rebuild switch --flake .#branda --target-host evan@192.168.2.9 --use-remote-sudo
titans:
    nixos-rebuild switch --flake .#eldric --target-host evan@192.168.2.8 --use-remote-sudo
    nixos-rebuild switch --flake .#branda --target-host evan@192.168.2.9 --use-remote-sudo