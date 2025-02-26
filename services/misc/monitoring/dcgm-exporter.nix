{ ... }: {
  virtualisation.oci-containers.containers."dcgm-exporter" = {
    image = "nvcr.io/nvidia/k8s/dcgm-exporter:latest";
    autoStart = true;
    extraOptions = [
      "--runtime=nvidia"
      "--gpus=all"
    ];
    ports = [ "9400:9400" ];
  };
}