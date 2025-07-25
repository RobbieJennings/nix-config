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
  };

  config = lib.mkMerge [
    (lib.mkIf config.backup.restic.enable {
      home.packages = with pkgs; [
        restic
        restic-browser
      ];
    })

    (lib.mkIf (config.backup.restic.enable && config.secrets.enable) {
      services.restic.backups.backup = {
        repositoryFile = config.sops.secrets."restic/repository".path;
        passwordFile = config.sops.secrets."restic/password".path;
        paths = [
          "~/Documents"
          "~/Pictures"
          "~/Books"
        ];
        timerConfig = {
          OnCalendar = "00:00";
          RandomizedDelaySec = "45m";
          Persistent = true;
        };
      };
    })
  ];
}
