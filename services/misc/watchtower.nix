{ lib, ... }: {
  virtualisation.oci-containers.containers."watchtower" = {
    image = "docker.io/containerrr/watchtower:latest";
    autoStart = true;
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
    ];
  };
}