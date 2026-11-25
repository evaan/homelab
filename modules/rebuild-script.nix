{ pkgs, hostName }:

pkgs.writeShellApplication {
  name = "${hostName}-rebuild";
  runtimeInputs = with pkgs; [
    coreutils
    jq
    nix
  ];
  text = ''
    if [[ "$(uname -n)" != "${hostName}" ]]; then
      echo "This rebuild command is only for ${hostName}." >&2
      exit 1
    fi

    workdir="$(mktemp -d)"
    trap 'rm -rf -- "$workdir"' EXIT

    flake_source="$(nix flake metadata --refresh --no-update-lock-file --json github:evaan/homelab | jq -er '.path')"
    cp -R "$flake_source/." "$workdir"
    chmod -R u+w "$workdir"

    /run/current-system/sw/bin/nixos-rebuild switch \
      --flake "$workdir#${hostName}" \
      --no-update-lock-file \
      --print-build-logs
  '';
}
