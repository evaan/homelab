{ config, ... }:

{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = {
      gluetun-env = {};
      postgres-env = {};
      watchtower-env = {};
      restic-env = {};
      restic-repo = {};
      restic-password = {};
      duckdns-env = {};
      cloudflare-env = {};
      beszel-agent-env = {};
      tmodloader-env = {};
      flame-env = {};
    };
  };
}