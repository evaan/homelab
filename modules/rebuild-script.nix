{ pkgs }:

pkgs.writeShellApplication {
  name = "sotetseg-rebuild";
  runtimeInputs = with pkgs; [
    coreutils
    jq
    nix
  ];
  text = ''
    workdir="$(mktemp -d)"
    trap 'rm -rf -- "$workdir"' EXIT

    flake_source="$(nix flake metadata --refresh --no-update-lock-file --json github:evaan/homelab | jq -er '.path')"
    cp -R "$flake_source/." "$workdir"
    chmod -R u+w "$workdir"

    /run/current-system/sw/bin/nixos-rebuild switch \
      --flake "$workdir#sotetseg" \
      --no-update-lock-file \
      --print-build-logs
  '';
}
