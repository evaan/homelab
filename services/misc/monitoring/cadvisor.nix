{ lib, ... }: {
  virtualisation.oci-containers.containers."cadvisor" = {
    image = "gcr.io/cadvisor/cadvisor:latest";
    autoStart = true;
    ports = [ "8087:8080" ];
    extraOptions = [
      "--privileged"
      "--device=/dev/kmsg"
    ];
    volumes = [
      "/:/rootfs:ro"
      "/var/run:/var/run:ro"
      "/sys:/sys:ro"
      "/var/lib/docker:/var/lib/docker:ro"
      "/dev/disk/:/dev/disk:ro"
    ];
  };
}