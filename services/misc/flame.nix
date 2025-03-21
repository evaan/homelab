{ config, ... }: {
  virtualisation.oci-containers.containers."flame" = {
    image = "docker.io/pawelmalak/flame:multiarch";
    autoStart = true;
    ports = [ "5005:5005" ];
    environmentFiles = [
      config.sops.secrets.flame-env.path
    ];
    volumes = [
      "flame-data:/app/data"
    ];
  };
}