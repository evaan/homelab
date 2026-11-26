{ pkgs, ... }:

{
  virtualisation.oci-containers.containers.postgres = {
    image = "postgres:17";
    labels."dev.vigil.enable" = "true";
    environment = {
      POSTGRES_USER = "postgres";
      POSTGRES_PASSWORD = "claret";
      POSTGRES_DB = "claret";
      TZ = "America/St_Johns";
    };
    volumes = [
      "postgres-data:/var/lib/postgresql/data"
      "${pkgs.writeText "postgres-init.sql" ''
        CREATE DATABASE inventory;
        CREATE DATABASE medtech;
      ''}:/docker-entrypoint-initdb.d/init.sql:ro"
    ];
    ports = [ "5432:5432" ];
  };
}
