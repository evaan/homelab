{ ... }:

{
  services.cloudflare-ddns = {
    enable = true;
    credentialsFile = "/var/lib/secrets/cloudflare-ddns.env";
    domains = [
      "claretformun.com"
      "memorialmedtech.ca"
    ];
    provider.ipv6 = "none";
    proxied = "true";
    updateCron = "@every 5m";
    updateOnStart = true;
    deleteOnStop = false;
  };
}
