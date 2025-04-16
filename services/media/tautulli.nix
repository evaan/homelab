{ ... }: {
  virtualisation.oci-containers.containers."tautulli" = {
    image = "docker.io/linuxserver/tautulli:latest";
    autoStart = true;
    ports = [ "8181:8181" ];
    environment = {
      PUID = "1000";
      PGID = "1000";
    };
    volumes = [
      "tautulli-config:/config"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
