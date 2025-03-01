{ lib, ...}:  {
  virtualisation.oci-containers.containers."flaresolverr" = {
    image = "ghcr.io/flaresolverr/flaresolverr:latest";
    autoStart = true;
    ports = [ "8191:8191" ];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}