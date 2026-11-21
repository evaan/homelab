{ config, lib, ... }:

{
  options.virtualisation.oci-containers.containers = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      config = {
        autoRemoveOnStop = lib.mkDefault false;
        labels."dev.vigil.scope" = lib.mkDefault "sotetseg-flake";
        extraOptions = [
          "--detach"
          "--restart=unless-stopped"
        ];
      };
    });
  };

  config = {
    virtualisation.oci-containers.backend = "docker";

    systemd.services = lib.mapAttrs' (_: container:
      lib.nameValuePair container.serviceName {
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      }
    ) config.virtualisation.oci-containers.containers;
  };
}
