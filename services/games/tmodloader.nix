{ lib, ...}: {
  virtualisation.oci-containers.containers."tmodloader" = {
    image = "docker.io/jacobsmile/tmodloader1.4:latest";
    autoStart = true;
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