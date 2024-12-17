# Homelab Nix Configurations
Welcome to my homelab Nix configurations repository! This flake manages two machines in my homelab cluster, managed through NixOS.

## Services Overview (sotetseg)
### Media Managment
 - **Sonarr**, **Radarr**, **Lidarr** - Media library management
    - An additional Radarr instance is hosted for 4K media.
 - **Prowlarr** - Indexer manager for Sonarr, Radarr, and Lidarr.
 - **qBittorrent** - Torrent Client.
 - **Plex** - Media streaming server.
 - **Tautulli** - Plex analytics tool.
### Backup & Synchronization
 - **Restic** - Automated backups to my Backblaze B2 bucket.
 - **Syncthing** - Continuous file synchronization between my laptop, desktop, and homelab.
### Games & Miscellaneous
 - **Watchtower** - Automated updates for Podman containers.
 - **PostgreSQL** - Database used for projects when needed.
 - **Minecraft** - Minecraft server using [nix-minecraft](https://github.com/Infinidoge/nix-minecraft).

## Services Overview (kephri)
### Networking
 - **Caddy** - Reverse proxy with automatic HTTPS for internal services.
 - **Tailscale** - Peer-to-peer VPN, used for allowing local network without a typical VPN.
 - **DuckDNS** - Dynamic DNS updater.
 - **AdGuard Home** - Ad-Blocking DNS server.
### Miscellaneous
 - **Watchtower** - Automated updates for Podman containers.
 - **Vaultwarden** - Free, self-hosted Bitwarden server.
 - **Uptime Kuma** - Service health and uptime monitoring.
 - **Nginx** - Static page (mine uses [homer](https://github.com/bastienwirtz/homer))
