{ ... }: {
  virtualisation.oci-containers.containers."radarr" = {
    image = "docker.io/linuxserver/radarr:latest";
    autoStart = true;
    ports = [ "7878:7878" ];
    environment = {
      PUID = "1000";
      PGID = "1000";
    };
    volumes = [
      "radarr-config:/config"
      "/mnt/storage:/media"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
