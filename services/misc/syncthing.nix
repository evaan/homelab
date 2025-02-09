{ lib, ... }: {
  virtualisation.oci-containers.containers."syncthing" = {
    image = "docker.io/linuxserver/syncthing:latest";
    autoStart = true;
    ports = [ "8384:8384" "22000:22000" "22000:22000/udp" "21027:21027/udp" ];
    environment = {
      PUID = "1000";
      PGID = "1000";
    };
    volumes = [
      "syncthing-config:/config"
      "/mnt/storage/Backups:/backups"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}