{ lib, ...}: {
  imports = [ ../misc/gluetun.nix ];

  virtualisation.oci-containers.containers."sabnzbd" = {
    image = "docker.io/linuxserver/sabnzbd:latest";
    autoStart = true;
    dependsOn = [ "gluetun" ];
    extraOptions = [
      "--memory=4g"
    ];
    environment = {
      PUID = "1000";
      PGID = "1000";
    };
    volumes = [
      "qbittorrent-config:/config"
      "/mnt/storage:/media"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}