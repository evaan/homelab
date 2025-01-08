{ lib, config, ... }: {
  virtualisation.oci-containers.containers."grafana" = {
    image = "docker.io/grafana/grafana:latest";
    autoStart = true;
    ports = [ "3000:3000" ];
    volumes = [
      "grafana-storage:/var/lib/grafana"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };

  systemd.services."docker-grafana" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
  };
}