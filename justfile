sotetseg:
  sudo nixos-rebuild switch --flake .#sotetseg
buildKephri:
  nix run nixpkgs#nixos-generators -- -f sd-aarch64 --flake .#kephri --system aarch64-linux -o ./kephri.sd
kephri:
  nixos-rebuild switch --flake .#kephri --target-host evan@192.168.7.4 --use-remote-sudo
format:
  docker run -it --rm -v "$PWD":/workspace -w /workspace nixos/nix nix --extra-experimental-features nix-command --extra-experimental-features flakes run nixpkgs#nixpkgs-fmt -- .
  docker run -it --rm -v "$PWD":/workspace -w /workspace nixos/nix nix --extra-experimental-features nix-command --extra-experimental-features flakes run nixpkgs#deadnix -- .
