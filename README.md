# Homelab

Minimal NixOS flake using **26.05**, the latest stable release at creation.

## Layout

- `flake.nix`: Nixpkgs input and the `sotetseg` host (`x86_64-linux`).
- `justfile`: shortcut for switching the `sotetseg` configuration.
- `.github/workflows/build.yaml`: GitHub Actions build check for `sotetseg`.
- `machines/sotetseg/configuration.nix`: base system configuration.
- `machines/sotetseg/hardware-configuration.nix`: kernel modules and disk mounts for `sotetseg`.
- `home/evan.nix`: Evan's Home Manager configuration, applied with the system rebuild.
- `modules/containers.nix`: shared Docker lifecycle and container scope settings.
- `services/plex/default.nix`: Plex container managed by NixOS using Docker.
- `services/vaultwarden/default.nix`: Vaultwarden container with persistent storage.
- `services/vigil/default.nix`: daily Docker container updates using Vigil.

## Set up

This scaffold uses systemd-boot on an Intel/AMD UEFI machine. Change `system` in
`flake.nix` for ARM, or the bootloader settings for legacy BIOS.

1. Verify the stored hardware configuration matches the target. The root and
   boot filesystems must be labelled `NIXROOT` and `NIXBOOT`, respectively.
   To replace it with the target NixOS machine's generated configuration:

   ```sh
   cp /etc/nixos/hardware-configuration.nix machines/sotetseg/hardware-configuration.nix
   ```

   For a fresh install, mount the target filesystems at `/mnt`, run
   `sudo nixos-generate-config --root /mnt`, and copy
   `/mnt/etc/nixos/hardware-configuration.nix` instead.

2. If adopting an existing installation, replace `system.stateVersion` with
   that installation's existing value. `26.05` is for a new installation.
   Review the generated filesystem and bootloader settings before proceeding.

3. Track the flake's files and generate the dependency lockfile:

   ```sh
   git add .github/workflows/build.yaml flake.nix justfile machines/sotetseg home modules/containers.nix services/plex services/vaultwarden services/vigil README.md
   nix --extra-experimental-features 'nix-command flakes' flake lock
   git add flake.lock
   ```

   Commit `flake.lock` to keep dependency versions reproducible.

4. On an existing NixOS installation, build and activate:

   ```sh
   sudo nixos-rebuild switch --flake .#sotetseg
   ```

   For a fresh installation, use `sudo nixos-install --flake .#sotetseg`
   instead. The `evan` user has key-only SSH access and passwordless sudo;
   root SSH login is disabled.

## Commands

With `just` installed, switch the configuration on the target NixOS machine:

```sh
just sotetseg
```

This runs `sudo nixos-rebuild switch --flake .#sotetseg`. Verify the hardware
configuration matches the target before rebuilding.

## CI

GitHub Actions builds the complete `sotetseg` system on pushes, pull requests,
and manual runs. It uses a Linux runner and never activates or deploys the
configuration.

Generate and commit `flake.lock` before expecting a successful build.
CI refuses to update the lockfile. A successful
build checks the NixOS configuration and its build dependencies, not whether
Docker images start, NFS mounts are reachable, or the physical hardware boots.

## Plex

Plex starts automatically through `docker-plex.service` after rebuilding.
Open <http://192.168.7.2:32400/web> to finish setup.

The LinuxServer image uses UID/GID `1000` and timezone `America/St_Johns`.
Docker creates the named volumes `plex-config` at `/config` and
`plex-transcode` at `/transcode`. Stopping the service preserves both volumes.
In Plex's transcoder settings, set the temporary directory to `/transcode`.

The Arceuus NFS mounts are available read-only inside Plex at `/tv`, `/movies`,
and `/4kmovies`. NVIDIA GPUs are passed through using the host's Container
Toolkit CDI integration. Enable hardware acceleration in Plex's transcoder
settings with Plex Pass.

```sh
sudo systemctl status docker-plex
sudo docker logs -f plex
sudo docker exec plex nvidia-smi
```

If the previous Compose deployment is already running, stop it with
`sudo systemctl stop plex-compose` before rebuilding. The named volumes
are reused by the NixOS-managed container.

## Vaultwarden

Vaultwarden starts automatically through `docker-vaultwarden.service`, using
`vaultwarden/server:latest`. Docker creates the named volume `vaultwarden-data`
at `/data`; stopping or recreating the container preserves it.

The service listens only on `127.0.0.1:8000` on the host. Configure an HTTPS
reverse proxy to this address and set the container's `DOMAIN` environment
variable to its public HTTPS URL before using it over the network. No reverse
proxy or TLS certificate is configured yet. The web vault requires a secure
context; plain HTTP access through the server's LAN address will not work.

Vigil includes Vaultwarden in its daily updates. Back up the data volume,
including a consistent database backup, before relying on automatic updates.

```sh
sudo systemctl status docker-vaultwarden
sudo docker logs -f vaultwarden
```

## Container updates

Vigil runs continuously as a Docker container through `docker-vigil.service`.
Its environment sets `VIGIL_SCHEDULE="0 0 6 * * *"` and
`TZ="America/St_Johns"` for daily checks at **6:00 a.m.**, including
daylight-saving changes. No systemd timer is needed. If the container is
stopped during a scheduled check, it waits for the next scheduled time.

Vigil only checks running containers labelled `dev.vigil.enable=true` in the
`sotetseg-flake` scope, recreating those with updated images. Plex, Vaultwarden,
and Vigil are explicitly whitelisted in their individual service modules using
`labels."dev.vigil.enable" = "true";`. New containers are not automatically
whitelisted; each requires this explicit opt-in. Shared defaults only apply the
scope label. Independently managed Compose projects and manually started
containers are excluded unless explicitly given both matching labels. Stopped
containers are left stopped. Remove the enable label or set it to `false` to
stop updating a container. Vigil still has full access to Docker through
`/var/run/docker.sock`; these filters are not a security boundary.

NixOS-declared containers run detached with Docker's `unless-stopped` restart
policy, allowing Vigil to replace them without racing systemd. Their systemd
units manage startup and shutdown and show `active (exited)`; use `docker ps`
and `docker logs` to inspect the actual containers. These defaults also apply
to future containers declared in `virtualisation.oci-containers.containers`.
The shared lifecycle settings live in `modules/containers.nix`, keeping each
service's own module focused on its container configuration.

Named volumes are preserved, but back up application data before relying on
unattended updates. Old images are not automatically removed.

```sh
sudo systemctl status docker-vigil
sudo docker logs -f vigil
```

## Extend

Add settings to `machines/sotetseg/configuration.nix`, or create NixOS modules
and add them to its `imports` list.

Keep each service in `services/<name>/default.nix` and add its directory to
the imports in `machines/sotetseg/configuration.nix`.

Manage Evan's user packages and dotfiles in `home/evan.nix`. Home Manager
uses the matching `release-26.05` branch and shares the system's Nixpkgs.
Keep `home.stateVersion` unchanged when upgrading Home Manager.

Update packages within the stable release with `nix flake update`. To move to
a newer NixOS release, change the input branch in `flake.nix` and update the
lockfile; do not automatically bump `system.stateVersion`.
