{ lib, ... }: {
  virtualisation.oci-containers.containers."glance" = {
    image = "docker.io/glanceapp/glance:latest";
    autoStart = true;
    ports = [ "84:8080" ];
    volumes = [
      "glance-config:/app/config"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}