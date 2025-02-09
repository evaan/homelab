{ lib, config, ... }: {
  virtualisation.oci-containers.containers."beszel-agent" = {
    image = "docker.io/henrygd/beszel-agent:latest";
    autoStart = true;
    ports = [ "45876:45876" ];
    environmentFiles = [
      config.sops.secrets.beszel-agent-env.path
    ];
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    environment = {
      PORT = "45876";
    };
  };
}