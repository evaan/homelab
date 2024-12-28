{ lib, ...}:  {
  virtualisation.oci-containers.containers."radarr4k" = {
    image = "docker.io/linuxserver/radarr:latest";
    autoStart = true;
    ports = [ "7879:7878" ];
    environment = {
      PUID = "1000";
      PGID = "1000";
    };
    volumes = [
      "radarr4k-config:/config"
      "/mnt/storage:/media"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };

  systemd.services."docker-radarr4k" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
  };
}