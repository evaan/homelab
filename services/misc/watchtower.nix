{ config, lib, ... }: {
  virtualisation.oci-containers.containers."watchtower" = {
    image = "docker.io/containrrr/watchtower:latest";
    autoStart = true;
    environmentFiles = [
      config.sops.secrets.watchtower-env.path
    ];
    environment = {
      "WATCHTOWER_RUN_ONCE" = "true";
    };
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}