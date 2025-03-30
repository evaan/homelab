{ config, ... }: 
let
  certloc = "/var/lib/acme/home.evaan.dev";
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  
  services.caddy = {
    enable = true;
    virtualHosts."home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.4:5005

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."sonarr.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:8989

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."radarr.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:7878

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."radarr4k.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:7879

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."qbittorrent.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:8081

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."sabnzbd.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:8080

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."prowlarr.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:9696

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."tautulli.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:8181

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."lidarr.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:8686

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."truenas.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.3:80

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."pikvm.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.7:80

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."uptime.home.evaan.dev".extraConfig = ''
      redir https://uptime.evaan.dev permanent

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."router.home.evaan.dev".extraConfig = ''
      redir http://192.168.7.1:80 permanent

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."adguard.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.4:3000

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."hass.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.5:8123

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."vaultwarden.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.4:88

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."syncthing.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:8384

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."grafana.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:3000

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."prometheus.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:9090

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."beszel.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:8090

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
    virtualHosts."tdarr.home.evaan.dev".extraConfig = ''
      reverse_proxy http://192.168.7.2:8265

      tls ${certloc}/cert.pem ${certloc}/key.pem {
        protocols tls1.3
      }
    '';
  };


  security.acme = {
    acceptTerms = true;
    defaults.email = "41494790+evaan@users.noreply.github.com";

    certs."home.evaan.dev" = {
      group = config.services.caddy.group;

      domain = "home.evaan.dev";
      extraDomainNames = [ "*.home.evaan.dev" ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.secrets.cloudflare-env.path;
    };
  };
}