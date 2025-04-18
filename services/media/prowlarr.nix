{ ... }: {
  imports = [ ../misc/gluetun.nix ];

  virtualisation.oci-containers.containers."prowlarr" = {
    image = "docker.io/linuxserver/prowlarr:latest";
    autoStart = true;
    # dependsOn = [ "gluetun" ];
    # extraOptions = [ "--network=container:gluetun" ];
    ports = [ "9696:9696" ];
    environment = {
      PUID = "1000";
      PGID = "1000";
    };
    volumes = [
      "prowlarr-config:/config"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
