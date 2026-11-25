{ config, lib, ... }:

let
  backendAddress = "192.168.7.2";
  caddyAddress = "192.168.7.4";
  ports = [ 3000 8000 8181 8281 8381 ];
  portList = lib.concatMapStringsSep "," toString ports;
  iptables = "${config.networking.firewall.package}/bin/iptables";

  dockerRule = port:
    "-p tcp ! -s ${caddyAddress} -m conntrack --ctdir ORIGINAL "
    + "--ctorigdst ${backendAddress} --ctorigdstport ${toString port} -j DROP";

  restrictDocker = ''
    if ! ${iptables} -w -n -L DOCKER-USER >/dev/null 2>&1; then
      ${iptables} -w -N DOCKER-USER
    fi
    ${lib.concatMapStringsSep "\n" (port: ''
      if ! ${iptables} -w -C DOCKER-USER ${dockerRule port} 2>/dev/null; then
        ${iptables} -w -I DOCKER-USER 1 ${dockerRule port}
      fi
    '') ports}
  '';
in
{
  assertions = [
    {
      assertion =
        config.networking.firewall.enable
        && config.networking.firewall.backend == "iptables"
        && config.virtualisation.docker.enable
        && (config.virtualisation.docker.daemon.settings.iptables or true)
        && (config.virtualisation.docker.daemon.settings."firewall-backend" or "iptables") == "iptables";
      message = "Caddy backend restrictions require the NixOS and Docker iptables firewalls.";
    }
  ];

  networking.firewall = {
    extraCommands = ''
      # Also protect any non-Docker backends, while preserving local access.
      ${iptables} -w -I nixos-fw 1 ! -i lo ! -s ${caddyAddress} \
        -d ${backendAddress} -p tcp -m multiport --dports ${portList} -j nixos-fw-refuse
      ${iptables} -w -A nixos-fw -s ${caddyAddress} -d ${backendAddress} \
        -p tcp -m multiport --dports ${portList} -j nixos-fw-accept
      ${restrictDocker}
    '';
    extraStopCommands = lib.concatMapStringsSep "\n" (port: ''
      ${iptables} -w -D DOCKER-USER ${dockerRule port} 2>/dev/null || true
    '') ports;
  };

  systemd.services.docker.postStart = restrictDocker;
}
