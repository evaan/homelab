{ lib, config, ... }: {
  virtualisation.oci-containers.containers."redis" = {
    image = "docker.io/redis:alpine";
    autoStart = true;
    ports = [ "6379:6379" ];
    volumes = [
      "redis-data:/data"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}