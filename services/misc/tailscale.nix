{
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--advertise-exit-node" "--advertise-routes=192.168.2.0/24" ];
  };
}