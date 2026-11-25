# Homelab

[![sotetseg](https://github.com/evaan/homelab/actions/workflows/sotetseg.yaml/badge.svg)](https://github.com/evaan/homelab/actions/workflows/sotetseg.yaml)
[![cerberus](https://github.com/evaan/homelab/actions/workflows/cerberus.yaml/badge.svg)](https://github.com/evaan/homelab/actions/workflows/cerberus.yaml)

## Sotetseg

- [Cloudflare DDNS](services/cloudflare-ddns) — Dynamic DNS updates.
- [Grafana](services/grafana) — Dashboards at `home.evaan.dev`, with persistent storage in the `grafana-data` Docker volume.
- [Plex](services/plex) — Media server.
- [Tailscale](services/tailscale) — VPN, exit node, and subnet routing for `192.168.7.0/24`.
- [Vaultwarden](services/vaultwarden) — Password manager.
- [Vigil](services/vigil) — Automatic container updates.

## Cerberus

- [Caddy](services/caddy) — HTTPS reverse proxy.
