{ lib, config, ... }: {
  virtualisation.oci-containers.containers."rdtclient" = {
    image = "docker.io/rogerfar/rdtclient:latest";
    autoStart = true;
    extraOptions = [
      "--network=host"
      "--memory=4g"
    ];
    volumes = [
      "rdtclient_data:/data/db"
      "/mnt/storage:/media"
    ];
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "America/St_Johns";
    };
  };

  networking.firewall.allowedTCPPorts = [ 6500 ];
}