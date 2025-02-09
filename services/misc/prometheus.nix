{ lib, config, ... }: {
  virtualisation.oci-containers.containers."prometheus" = {
    image = "docker.io/prom/prometheus:latest";
    autoStart = true;
    ports = [ "9090:9090" ];
    volumes = [
      "prometheus-data:/etc/prometheus"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}