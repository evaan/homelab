{ lib, ... }: {
  virtualisation.oci-containers.containers."uptime" = {
    image = "docker.io/louislam/uptime-kuma:1";
    autoStart = false;
    ports = [ "3001:3001" ];
    volumes = [
      "uptime-data:/app/data"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}