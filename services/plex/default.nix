{ ... }:

{
  networking.firewall.allowedTCPPorts = [ 32400 ];

  systemd.services.docker-plex.unitConfig.RequiresMountsFor = [
    ''"/mnt/arceuus/TV Shows"''
    "/mnt/arceuus/Movies"
    ''"/mnt/arceuus/4K Movies"''
  ];

  virtualisation.oci-containers.containers.plex = {
    image = "lscr.io/linuxserver/plex:latest";
    labels."dev.vigil.enable" = "true";
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "America/St_Johns";
      VERSION = "docker";
    };
    devices = [
      "/dev/dri/by-path/pci-0000:00:02.0-card:/dev/dri/card0"
      "/dev/dri/by-path/pci-0000:00:02.0-render:/dev/dri/renderD128"
    ];
    volumes = [
      "plex-config:/config"
      "plex-transcode:/transcode"
      "/mnt/arceuus/TV Shows:/tv:ro"
      "/mnt/arceuus/Movies:/movies:ro"
      "/mnt/arceuus/4K Movies:/4kmovies:ro"
    ];
    networks = [ "host" ];
  };
}
