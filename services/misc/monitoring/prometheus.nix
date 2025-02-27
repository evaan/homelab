{ config, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "1m";
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
          targets = [ "192.168.2.8:${toString config.services.prometheus.exporters.node.port}" "192.168.2.8:8087" ];
        }];
      }
      {
        job_name = "runescape";
        static_configs = [{
          targets = [ "localhost:8340" "localhost:8341" "localhost:8342" ];
        }];
      }
      {
        job_name = "hass";
        static_configs = [{
          targets = [ "192.168.2.5:8123" ];
        }];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 9090 ];
}