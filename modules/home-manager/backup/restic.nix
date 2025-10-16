{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    backup.restic.enable = lib.mkEnableOption "restic backups";
    secrets.restic.enable = lib.mkEnableOption "restic repository secrets";
  };

  config = lib.mkMerge [
    (lib.mkIf config.backup.restic.enable {
      home.packages = with pkgs; [
        restic
        restic-browser
      ];
    })

    (lib.mkIf (config.backup.restic.enable && config.secrets.enable && config.secrets.restic.enable) {
      sops.secrets = {
        "restic/repository" = { };
        "restic/password" = { };
      };
      services.restic = {
        enable = true;
        backups.daily = {
          repositoryFile = config.sops.secrets."restic/repository".path;
          passwordFile = config.sops.secrets."restic/password".path;
          paths = [
            "${config.home.homeDirectory}/Documents"
            "${config.home.homeDirectory}/Pictures"
            "${config.home.homeDirectory}/Books"
          ];
          pruneOpts = [
            "--keep-daily 3"
            "--keep-weekly 7"
            "--keep-monthly 15"
            "--keep-yearly 30"
          ];
          timerConfig = {
            OnCalendar = "00:00";
            RandomizedDelaySec = "45m";
            Persistent = true;
          };
        };
      };
    })
  ];
}
