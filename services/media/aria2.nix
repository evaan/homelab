{ config, lib, pkgs, ... }: {
  virtualisation.oci-containers.containers."aria2" = {
    image = "docker.io/p3terx/aria2-pro:latest";
    autoStart = true;
    ports = [
      "6800:6800"
    ];
    environment = {
      PUID = "1000";
      PGID = "0";
      ARIA2_FILE_ALLOCATION = "none";
    };
    volumes = [
      "aria2_config:/config"
      "/mnt/storage:/media"
    ];
  };
}