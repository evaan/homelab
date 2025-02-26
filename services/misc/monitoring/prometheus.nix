{ config, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s";
    scrapeConfigs = [
    {
      job_name = "sotetseg";
      static_configs = [{
        targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
      }];
    }
    ];
  };

  allowedTCPPorts = [ 9090 ];
}