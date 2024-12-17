sotetseg:
    sudo nixos-rebuild switch --flake .#sotetseg
buildKephri:
    nix run nixpkgs#nixos-generators -- -f sd-aarch64 --flake .#kephri --system aarch64-linux -o ./kephri.sd
kephri:
    nixos-rebuild switch --flake .#kephri --target-host evan@192.168.2.8 --use-remote-sudo