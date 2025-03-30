{ lib, config, ... }: {
  virtualisation.oci-containers.containers."rdtclient" = {
    image = "docker.io/rogerfar/rdtclient:latest";
    autoStart = true;
    ports = [
      "6500:6500"
    ];
    volumes = [
      "rdtclient_data:/data/db"
      "rdtclient_downloads:/data/downloads"
    ];
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "America/St_Johns";
    };
  };
}