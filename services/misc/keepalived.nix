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
          notify_master = "${pkgs.docker}/bin/docker start vaultwarden adguard uptime"
          notify_backup = "${pkgs.docker}/bin/docker stop vaultwarden adguard uptime"
          notify_fault = "${pkgs.docker}/bin/docker stop vaultwarden adguard uptime"
        '';
      };
    };
  };
}