{ lib, config, ... }: {
  virtualisation.oci-containers.containers."postgres" = {
    image = "docker.io/postgres:alpine";
    autoStart = true;
    ports = [ "5432:5432" ];
    environmentFiles = [
      config.sops.secrets.postgres-env.path
    ];
    volumes = [
      "postgres-data:/var/lib/postgresql/data"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };

  systemd.services."podman-postgres" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
  };
}