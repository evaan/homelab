{ ... }:

{
  services.adguardhome = {
    enable = true;
    host = "127.0.0.1";
    port = 3000;
    mutableSettings = true;
    settings = {
      dns = {
        bind_hosts = [
          "127.0.0.1"
          "192.168.7.4"
        ];
        port = 53;
        upstream_dns = [ "https://dns.google/dns-query" ];
        bootstrap_dns = [
          "8.8.8.8"
          "8.8.4.4"
        ];
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
      };
      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
      ];
    };
  };

  networking.firewall.interfaces.enp2s0 = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
