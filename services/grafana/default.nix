{ ... }:

{
  virtualisation.oci-containers.containers.grafana = {
    image = "grafana/grafana:latest";
    labels."dev.vigil.enable" = "true";
    environment = {
      GF_SERVER_DOMAIN = "home.evaan.dev";
      GF_SERVER_ROOT_URL = "https://home.evaan.dev";
      GF_SECURITY_COOKIE_SECURE = "true";
      GF_USERS_ALLOW_SIGN_UP = "false";
      TZ = "America/St_Johns";
    };
    volumes = [
      "grafana-data:/var/lib/grafana"
    ];
    ports = [ "192.168.7.2:3000:3000" ];
  };
}
