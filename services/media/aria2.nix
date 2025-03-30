{ lib, config, ... }: {
  virtualisation.oci-containers.containers."aria2" = {
    image = "docker.io/p3terx/aria2-pro:latest";
    autoStart = true;
    dependsOn = [ "gluetun" ];
    extraOptions = [
      "--network=container:gluetun"
      "--memory=4g"
    ];
    volumes = [
      "/mnt/storage/aria2:/downloads"
      "aria2_config:/config"
    ];
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "America/St_Johns";
    };
  };
}