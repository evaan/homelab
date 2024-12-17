{ config, lib, ... }: {
  virtualisation.oci-containers.containers."duckdns" = {
    image = "docker.io/linuxserver/duckdns:latest";
    autoStart = true;
    environmentFiles = [
      config.sops.secrets.duckdns-env.path
    ];
    environment = {
      PUID = "1000";
      PGID = "1000";
      UPDATE_IP = "ipv4";
      LOG_FILE = "false";
    };
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
    ];
  };

  systemd.services."podman-duckdns" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
  };
}