{ lib, ...}:  {
  virtualisation.oci-containers.containers."lidarr" = {
    image = "docker.io/linuxserver/lidarr:latest";
    autoStart = true;
    ports = [ "8686:8686" ];
    environment = {
      PUID = "1000";
      PGID = "1000";
    };
    volumes = [
      "lidarr-config:/config"
      "/mnt/storage:/media"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}