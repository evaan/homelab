{ ... }:

{
  services.caddy = {
    enable = true;
    openFirewall = true;
    virtualHosts."vaultwarden.home.evaan.dev" = {
      useACMEHost = "vaultwarden.home.evaan.dev";
      extraConfig = ''
        @allowed remote_ip 192.168.7.0/24 100.64.0.0/10 fd7a:115c:a1e0::/48 127.0.0.1 ::1
        handle @allowed {
          reverse_proxy 127.0.0.1:8000
        }
        handle {
          respond "Forbidden" 403
        }
      '';
    };
  };

  security.acme = {
    acceptTerms = true;
    certs."vaultwarden.home.evaan.dev" = {
      dnsProvider = "cloudflare";
      dnsResolver = "8.8.8.8:53";
      environmentFile = "/var/lib/secrets/caddy-cloudflare.env";
      enableDebugLogs = false;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/secrets 0700 root root -"
  ];
}
