{ ... }:

{
  virtualisation.oci-containers.containers.redis = {
    image = "redis:8";
    labels."dev.vigil.enable" = "true";
    cmd = [
      "redis-server"
      "--appendonly"
      "yes"
      "--protected-mode"
      "no"
    ];
    volumes = [
      "redis-data:/data"
    ];
    ports = [ "6379:6379" ];
  };
}
