{ lib, config, ... }: {
  virtualisation.oci-containers.containers."plex" = {
    image = "docker.io/linuxserver/plex:latest";
    autoStart = true;
    extraOptions = [ "--device=nvidia.com/gpu=all" ];
    ports = [ "32400:32400" "1900:1900/udp" "5353:5353/udp" "8324:8324" "32410:32410/udp" "32412-32414:32412-32414/udp" "32469:32469" ];
    environment = {
      PUID = "1000";
      PGID = "1000";
    };
    volumes = [
      "plex-config:/config"
      "/mnt/storage:/media"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };

  systemd.services."podman-plex" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
  };
}