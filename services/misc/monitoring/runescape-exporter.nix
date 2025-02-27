{ ... }: {
  virtualisation.oci-containers.containers."runescape-exporter-gaming-rn" = {
    image = "docker.io/evaan/runescape-exporter:latest";
    autoStart = true;
    ports = [ "8340:8340" ];
    environment = {
      PLAYER_NAME = "gaming rn";
    };
  };

  virtualisation.oci-containers.containers."runescape-exporter-zoingus" = {
    image = "docker.io/evaan/runescape-exporter:latest";
    autoStart = true;
    ports = [ "8341:8341" ];
    environment = {
      PLAYER_NAME = "zoingus";
      PORT = "8341";
    };
  };

  virtualisation.oci-containers.containers."runescape-exporter-good-ass-job" = {
    image = "docker.io/evaan/runescape-exporter:latest";
    autoStart = true;
    ports = [ "8342:8342" ];
    environment = {
      PLAYER_NAME = "good ass job";
      PORt = "8342";
    };
  };
}