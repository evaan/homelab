# Homelab

[![sotetseg](https://github.com/evaan/homelab/actions/workflows/sotetseg.yaml/badge.svg)](https://github.com/evaan/homelab/actions/workflows/sotetseg.yaml)
[![cerberus](https://github.com/evaan/homelab/actions/workflows/cerberus.yaml/badge.svg)](https://github.com/evaan/homelab/actions/workflows/cerberus.yaml)

```mermaid
flowchart TB
    sotetseg["Sotetseg"]
    cerberus["Cerberus"]

    sotetseg --> grafana["Grafana"]
    sotetseg --> plex["Plex"]
    sotetseg --> vaultwarden["Vaultwarden"]
    sotetseg --> vigil["Vigil"]

    cerberus --> adguard["AdGuard Home"]
    cerberus --> caddy["Caddy"]
    cerberus --> ddns["Cloudflare DDNS"]
    cerberus --> tailscale["Tailscale"]
```
