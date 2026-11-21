{ lib, ... }:

let
  privateSites = {
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

  publicSites = {
    "claretformun.com" = "reverse_proxy http://127.0.0.1:8181";
    "www.claretformun.com" = "reverse_proxy http://127.0.0.1:8181";
    "api.claretformun.com" = "reverse_proxy http://127.0.0.1:8181";
    "memorialmedtech.ca" = "reverse_proxy http://127.0.0.1:8281";
    "www.memorialmedtech.ca" = "reverse_proxy http://127.0.0.1:8281";
    "app.memorialmedtech.ca" = "reverse_proxy http://127.0.0.1:8281";
    "demo.memorialmedtech.ca" = "reverse_proxy http://127.0.0.1:8281";
    "inventory.evaan.dev" = "reverse_proxy http://127.0.0.1:8381";
  };

  privateNetworks = [
    "192.168.7.0/24"
    "100.64.0.0/10"
    "fd7a:115c:a1e0::/48"
    "127.0.0.1"
    "::1"
  ];

  cloudflareNetworks = [
    "173.245.48.0/20"
    "103.21.244.0/22"
    "103.22.200.0/22"
    "103.31.4.0/22"
    "141.101.64.0/18"
    "108.162.192.0/18"
    "190.93.240.0/20"
    "188.114.96.0/20"
    "197.234.240.0/22"
    "198.41.128.0/17"
    "162.158.0.0/15"
    "104.16.0.0/13"
    "104.24.0.0/14"
    "172.64.0.0/13"
    "131.0.72.0/22"
  ];

  mkVirtualHosts = networks: sites:
    lib.mapAttrs (name: action: {
      useACMEHost = name;
      extraConfig = ''
        @allowed remote_ip ${lib.concatStringsSep " " networks}
        handle @allowed {
          ${action}
        }
        handle {
          respond "Forbidden" 403
        }
      '';
    }) sites;
in
{
  services.caddy = {
    enable = true;
    openFirewall = true;
    virtualHosts =
      mkVirtualHosts privateNetworks privateSites
      // mkVirtualHosts cloudflareNetworks publicSites;
  };

  security.acme = {
    acceptTerms = true;
    certs = lib.mapAttrs (_: _: {
      dnsProvider = "cloudflare";
      dnsResolver = "8.8.8.8:53";
      environmentFile = "/var/lib/secrets/caddy-cloudflare.env";
      enableDebugLogs = false;
    }) (privateSites // publicSites);
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/secrets 0700 root root -"
  ];
}
