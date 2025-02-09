{ lib, ... }: {
  virtualisation.oci-containers.containers."homer" = {
    image = "docker.io/nginx:alpine";
    autoStart = true;
    ports = [ "84:80" ];
    volumes = [
      "homer-html:/usr/share/nginx/html"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}