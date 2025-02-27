{ config, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s";
    scrapeConfigs = [
    {
      job_name = "sotetseg";
      static_configs = [{
        targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" "localhost:9400" "localhost:8087" ];
      }];
    }
    {
      job_name = "kephri";
      static_configs = [{
        targets = [ "192.168.2.8:${toString config.services.prometheus.exporters.node.port}" "localhost:8087" ]
      }];
    }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 9090 ];
}