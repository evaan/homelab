{ ... }: {
  environment.etc."keepalived/start.sh" = {
    text = ''
      systemctl start docker-vaultwarden docker-adguard docker-uptime
    '';
    mode = "0755";
  };

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
          notify_master /etc/keepalived/start.sh
          notify_backup "systemctl stop docker-vaultwarden docker-adguard docker-uptime"
          notify_fault "systemctl stop docker-vaultwarden docker-adguard docker-uptime"
        '';
      };
    };
  };
}