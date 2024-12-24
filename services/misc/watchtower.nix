{ lib, config, ...}:  {
  virtualisation.oci-containers.containers."watchtower" = {
    image = "docker.io/containrrr/watchtower:latest";
    autoStart = true;
    environmentFiles = [
      config.sops.secrets.watchtower-env.path
    ];
    environment = {
      WATCHTOWER_SCHEDULE = "0 30 4 * * 1";
      WATCHTOWER_CLEANUP = "true";
    };
    volumes = [
      "/var/run/podman/podman.sock:/var/run/docker.sock"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };

    systemd.services."docker-watchtower" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
  };
}