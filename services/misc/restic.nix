{ config, ... }: {
  services.restic.backups.backblaze = {
    initialize = true;

    environmentFile = config.sops.secrets.restic-env.path;
    repositoryFile = config.sops.secrets.restic-repo.path;
    passwordFile = config.sops.secrets.restic-password.path;

    paths = [
      "/mnt/storage/Backups"
      "/srv/minecraft"
    ];

    exclude = [
      "**/node_modules/"
    ];

    pruneOpts = [
      "--keep-daily 1"
      "--keep-weekly 2"
      "--keep-monthly 1"
    ];
  };
}