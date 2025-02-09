{ lib, ...}: {
  imports = [ ../misc/gluetun.nix ];

  virtualisation.oci-containers.containers."qbittorrent" = {
    image = "docker.io/linuxserver/qbittorrent:latest";
    autoStart = true;
    dependsOn = [ "gluetun" ];
    extraOptions = [
      "--network=container:gluetun"
      "--memory=4g"
    ];
    environment = {
      PUID = "1000";
      PGID = "1000";
      WEBUI_PORT = "8080";
      TORRENTING_PORT = "6881";
      DOCKER_MODS = "ghcr.io/vuetorrent/vuetorrent-lsio-mod:latest";
    };
    volumes = [
      "qbittorrent-config:/config"
      "/mnt/storage:/media"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}