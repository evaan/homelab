{ lib, config, ... }: {
  virtualisation.oci-containers.containers."tdarr" = {
    image = "ghcr.io/haveagitgat/tdarr:latest";
    autoStart = true;
    ports = [
      "8265:8265"
      "8266:8266"
    ];
    extraOptions = [
      "--gpus=all"
      "--log-opt=max-size=10m"
      "--log-opt=max-file=5"
      "--memory=8g"
    ];
    volumes = [
      "tdarr_server:/app/server"
      "tdarr_config:/app/configs"
      "tdarr_logs:/app/logs"
      "tdarr_temp:/temp"
      "/media:/media"
      "/etc/localtime:/etc/localtime:ro"
    ];
    environment = {
      serverIP = "0.0.0.0";
      serverPort = "8266";
      webUIPort = "8265";
      internalNode = "true";
      inContainer = "true";
      ffmpegVersion = "7";
      nodeName = "sotetseg";
      PUID = "1000";
      PGID = "1000";
      NVIDIA_DRIVER_CAPABILITIES = "all";
      NVIDIA_VISIBLE_DEVICES = "all";
    };
  };
}