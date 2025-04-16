{ ... }: {
  virtualisation.oci-containers.containers."vaultwarden" = {
    image = "docker.io/vaultwarden/server:latest";
    autoStart = true;
    ports = [ "88:80" ];
    volumes = [
      "vaultwarden-data:/data"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
