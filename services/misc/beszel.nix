{ lib, ... }: {
  virtualisation.oci-containers.containers."beszel" = {
    image = "docker.io/henrygd/beszel:latest";
    autoStart = true;
    ports = [ "8090:8090" ];
    volumes = [
      "beszel-data:/beszel_data"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}