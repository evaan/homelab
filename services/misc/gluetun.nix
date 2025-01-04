{ lib, config, ... }: {
  virtualisation.oci-containers.containers."gluetun" = {
    image = "docker.io/qmcgaw/gluetun:latest";
    autoStart = true;
    ports = [ "8080:8080" "9696:9696" ];
    extraOptions = [ "--cap-add=NET_ADMIN" "--device=/dev/net/tun:/dev/net/tun" ];
    environmentFiles = [
      config.sops.secrets.gluetun-env.path
    ];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
    ];
    labels = {
      "com.centurylinklabs.watchtower.enable" = "false";
    };
  };

  systemd.services."docker-gluetun" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
  };
}