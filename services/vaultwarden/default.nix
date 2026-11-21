{ ... }:

{
  virtualisation.oci-containers.containers.vaultwarden = {
    image = "vaultwarden/server:latest";
    labels."dev.vigil.enable" = "true";
    environment = {
      TZ = "America/St_Johns";
    };
    volumes = [
      "vaultwarden-data:/data"
    ];
    ports = [ "127.0.0.1:8000:80" ];
  };
}
