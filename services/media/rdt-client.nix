{ lib, config, ... }: {
  virtualisation.oci-containers.containers."rdtclient" = {
    image = "docker.io/rogerfar/rdtclient:latest";
    autoStart = true;
    dependsOn = [ "gluetun" ];
    extraOptions = [
      "--network=container:gluetun"
      "--memory=4g"
    ];
    volumes = [
      "rdtclient_data:/data/db"
      "/mnt/storage:/media"
    ];
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "America/St_Johns";
    };
  };
}