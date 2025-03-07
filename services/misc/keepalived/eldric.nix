{
  services.keepalived = {
    enable = true;

    vrrpInstances = {
      "nfs_failover" = {
        state = "BACKUP";
        interface = "eth0";
        virtualRouterId = 69;
        priority = 101; 
        virtualIps = [{ addr = "192.168.2.6/24"; }];
        unicastPeers = [ "192.168.2.8" "192.168.2.9" ];
      };
    };
  };
}