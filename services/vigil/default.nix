{ ... }:

{
  virtualisation.oci-containers.containers.vigil = {
    image = "ghcr.io/nitroxaddict/vigil:latest";
    labels."dev.vigil.enable" = "true";
    environment = {
      TZ = "America/St_Johns";
      VIGIL_LABEL_ENABLE = "true";
      VIGIL_SCOPE = "sotetseg-flake";
      VIGIL_SCHEDULE = "0 0 6 * * *";
    };
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
    ];
  };
}
