{ lib, ...}: {
  virtualisation.oci-containers.containers."sonarr" = {
    image = "docker.io/linuxserver/sonarr:latest";
    autoStart = true;
    ports = [ "8989:8989" ];
    environment = {
      PUID = "1000";
      PGID = "1000";
    };
    volumes = [
      "sonarr-config:/config"
      "/mnt/storage:/media"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}