{ lib, ... }: {
  virtualisation.oci-containers.containers."adguard" = {
    image = "docker.io/adguard/adguardhome:latest";
    autoStart = true;
    ports = [ "53:53" "53:53/udp" "3000:3000" ];
    volumes = [
      "adguard-conf:/opt/adguardhome/conf"
      "adguard-work:/opt/adguardhome/work"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };

  systemd.services."podman-adguard" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
  };
}