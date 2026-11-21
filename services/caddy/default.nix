{ lib, ... }:

let
  sites = {
    "vaultwarden.home.evaan.dev" = "reverse_proxy 127.0.0.1:8000";
    "truenas.home.evaan.dev" = "reverse_proxy http://192.168.7.3:80";
    "pikvm.home.evaan.dev" = "reverse_proxy http://192.168.7.7:80";
    "router.home.evaan.dev" = "redir http://192.168.7.1:80{uri} permanent";
    "prowlarr.home.evaan.dev" = "reverse_proxy http://192.168.7.3:9696";
    "radarr.home.evaan.dev" = "reverse_proxy http://192.168.7.3:7878";
    "radarr4k.home.evaan.dev" = "reverse_proxy http://192.168.7.3:7879";
    "rdtclient.home.evaan.dev" = "reverse_proxy http://192.168.7.3:30249";
    "sabnzbd.home.evaan.dev" = "reverse_proxy http://192.168.7.3:30055";
    "sonarr.home.evaan.dev" = "reverse_proxy http://192.168.7.3:8989";
    "syncthing.home.evaan.dev" = "reverse_proxy http://192.168.7.3:20910";
  };
in
{
  services.caddy = {
    enable = true;
    openFirewall = true;
    virtualHosts = lib.mapAttrs (name: action: {
      useACMEHost = name;
      extraConfig = ''
        @allowed remote_ip 192.168.7.0/24 100.64.0.0/10 fd7a:115c:a1e0::/48 127.0.0.1 ::1
        handle @allowed {
          ${action}
        }
        handle {
          respond "Forbidden" 403
        }
      '';
    }) sites;
  };

  security.acme = {
    acceptTerms = true;
    certs = lib.mapAttrs (_: _: {
      dnsProvider = "cloudflare";
      dnsResolver = "8.8.8.8:53";
      environmentFile = "/var/lib/secrets/caddy-cloudflare.env";
      enableDebugLogs = false;
    }) sites;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/secrets 0700 root root -"
  ];
}
