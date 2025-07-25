{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    backup.rclone.enable = lib.mkEnableOption "rclone google drive remote";
  };

  config = lib.mkMerge [
    (lib.mkIf config.backup.rclone.enable {
      programs.rclone.enable = true;
    })

    (lib.mkIf (config.backup.rclone.enable && config.secrets.enable) {
      programs.rclone.remotes.gdrive = {
        config = {
          type = "drive";
          scope = "drive.file";
        };
        secrets = {
          client_id = config.sops.secrets."rclone/client_id".path;
          client_secret = config.sops.secrets."rclone/client_secret".path;
          token = config.sops.secrets."rclone/access_token".path;
        };
      };
    })
  ];
}
