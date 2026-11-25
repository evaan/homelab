{ ... }:

{
  virtualisation.oci-containers.containers.vaultwarden = {
    image = "vaultwarden/server:latest";
    labels."dev.vigil.enable" = "true";
    environment = {
      DOMAIN = "https://vaultwarden.home.evaan.dev";
      IP_HEADER = "X-Forwarded-For";
      TZ = "America/St_Johns";
    };
    volumes = [
      "vaultwarden-data:/data"
    ];
    ports = [ "192.168.7.2:8000:80" ];
  };
}
