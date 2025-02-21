{ config, ...}: {
  virtualisation.oci-containers.containers."tmodloader" = {
    image = "docker.io/jacobsmile/tmodloader1.4:latest";
    autoStart = true;
    ports = [ "7777:7777" ];
    extraOptions = [
      "--memory=4g"
    ];
    environmentFiles = [
      config.sops.secrets.tmodloader-env.path
    ];
    volumes = [
      "tmodloader-data:/data"
    ];
  };
}