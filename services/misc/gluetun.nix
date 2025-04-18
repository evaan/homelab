{ config, ... }: {
  virtualisation.oci-containers.containers."gluetun" = {
    image = "docker.io/qmcgaw/gluetun:latest";
    autoStart = true;
    ports = [ "8080:8080" "8081:8081" ];
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
}
