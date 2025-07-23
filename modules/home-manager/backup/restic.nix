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
        rclone
        restic
        restic-browser
      ];

      services.restic.backups.gdrive = {
        user = "backups";
        paths = [ "~/Documents" ];
        timerConfig = {
          OnCalendar = "00:00";
          RandomizedDelaySec = "45m";
        };
      };
    })

    (lib.mkIf (config.backup.restic.enable && config.secrets.enable) {
      sops.templates = {
        "restic-repository".content = "${config.sops.placeholder."restic/repository"}";
        "restic-password".content = "${config.sops.placeholder."restic/password"}";
        "restic-rclone.conf".content = ''
          [gdrive]
          type = drive
          client_id = ${config.sops.placeholder."restic/rclone/client_id"}
          client_secret = ${config.sops.placeholder."restic/rclone/client_secret"}
          token = ${config.sops.placeholder."restic/rclone/access_token"}
        '';
      };

      services.restic.backups.gdrive = {
        repositoryFile = config.sops.templates."restic-repository".path;
        passwordFile = config.sops.templates."restic-password".path;
        rcloneConfigFile = config.sops.templates."restic-rclone.conf".path;
      };
    })
  ];
}
