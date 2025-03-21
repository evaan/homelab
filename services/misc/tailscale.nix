{
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--advertise-exit-node" "--advertise-routes=192.168.7.0/24" ];
  };
}