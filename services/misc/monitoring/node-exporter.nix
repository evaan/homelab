{ ... }: {
  services.prometheus.exporters.node = {
    enable = true;
    port = 9000;
  };
}