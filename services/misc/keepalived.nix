{ pkgs, ... }: {
  services.keepalived = {
    enable = true;

    vrrpInstances = {
      "titans" = {
        state = "BACKUP";
        interface = "enu1u1u1";
        virtualRouterId = 69;
        virtualIps = [{ addr = "192.168.2.4/24"; }];
        unicastPeers = [ "192.168.2.8" "192.168.2.9" ];
        extraConfig = ''
          notify_master = "/run/current-system/sw/bin/systemctl start docker-vaultwarden.service docker-adguard.service docker-uptime.service"
          notify_backup = "/run/current-system/sw/bin/systemctl stop docker-vaultwarden.service docker-adguard.service docker-uptime.service"
          notify_fault = "/run/current-system/sw/bin/systemctl stop docker-vaultwarden.service docker-adguard.service docker-uptime.service"
        '';
      };
    };
  };
}