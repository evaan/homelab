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
- `services/caddy/default.nix`: HTTPS reverse proxy with Cloudflare DNS validation.
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
    git add .github/workflows/build.yaml flake.nix justfile machines/sotetseg home modules/containers.nix services/caddy services/plex services/vaultwarden services/vigil README.md
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

## Caddy

Caddy serves these HTTPS hostnames:

| Hostname | Destination |
| --- | --- |
| `vaultwarden.home.evaan.dev` | Reverse proxy to `127.0.0.1:8000` |
| `truenas.home.evaan.dev` | Reverse proxy to `http://192.168.7.3:80` |
| `pikvm.home.evaan.dev` | Reverse proxy to `http://192.168.7.7:80` |
| `router.home.evaan.dev` | Permanent HTTP 301 redirect to `http://192.168.7.1:80`, preserving the path and query |

Only clients in `192.168.7.0/24`, Tailscale's IPv4 range
`100.64.0.0/10`, Tailscale's IPv6 range `fd7a:115c:a1e0::/48`, and loopback
are allowed; other source addresses receive HTTP 403. This uses the actual
connection's source address, not forwarded headers. The shared rules apply to
all hostnames in the Caddy module's `sites` attribute set.

The TrueNAS and PiKVM upstream connections use unencrypted HTTP on the LAN.
After the router redirect, the browser connects directly to the router over
HTTP; it must be able to reach `192.168.7.1` itself.

Tailscale is not enabled yet. Once installed, use its ACLs/grants to control
which tailnet devices can connect. The Caddy rule is an IP allowlist, not a
Tailscale identity check; the IPv4 range is shared CGNAT space. Remote clients
also need DNS resolving these hostnames to the server's Tailscale IP, or a subnet
route to its LAN IP.

NixOS ACME obtains and renews a Let's Encrypt certificate for each hostname using Cloudflare
DNS-01, then reloads Caddy. No custom Caddy plugin is needed. The `evaan.dev`
zone must be managed by Cloudflare. Create an API token with **Zone / DNS /
Edit** and **Zone / Zone / Read**, scoped only to `evaan.dev`; do not use a
global API key.

Before rebuilding, create the secret file directly on **sotetseg**, never in
this repository:

```sh
sudo install -d -m 700 -o root -g root /var/lib/secrets
sudo touch /var/lib/secrets/caddy-cloudflare.env
sudo chown root:root /var/lib/secrets/caddy-cloudflare.env
sudo chmod 600 /var/lib/secrets/caddy-cloudflare.env
sudo nano /var/lib/secrets/caddy-cloudflare.env
```

Add this line, replacing the placeholder with your token:

```text
CF_DNS_API_TOKEN=your-cloudflare-api-token
```

Only the filename is in Nix; the token stays outside Git and the Nix store.
The file is required for certificate issuance and renewals, so keep it in place.
The ACME service reads it through systemd; Caddy does not need access to the token.

Configure your LAN DNS to resolve all four hostnames to `192.168.7.2`
(or add client hosts-file entries). Cloudflare validation creates temporary TXT
records; it does not configure this LAN DNS record for you. No public A record,
Cloudflare proxy, or router port forwarding is required.

Track the new module with `git add services/caddy`, then run `just sotetseg`.
The host firewall opens TCP 80/443 and UDP 443 for Caddy. HTTP redirects to HTTPS;
each site's proxy or redirect enforces the LAN/Tailscale restriction.

```sh
sudo systemctl status caddy
sudo journalctl -u acme-order-renew-vaultwarden.home.evaan.dev -u caddy -n 100 --no-pager
```

If initial issuance fails, Caddy may temporarily serve a self-signed certificate.
Fix the token/DNS issue and retry
`sudo systemctl restart acme-order-renew-vaultwarden.home.evaan.dev`.
Do not bypass certificate warnings.

## Vaultwarden

Vaultwarden starts automatically through `docker-vaultwarden.service`, using
`vaultwarden/server:latest`. Docker creates the named volume `vaultwarden-data`
at `/data`; stopping or recreating the container preserves it.

The service listens only on `127.0.0.1:8000` on the host, behind Caddy.
Its `DOMAIN` is `https://vaultwarden.home.evaan.dev`. Complete the Caddy token
and LAN DNS setup above before accessing the web vault.

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
