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
      sops.templates."rclone.conf".content = ''
        [gdrive]
        scope = drive.file
        type = drive
        client_id = ${config.sops.placeholder."rclone/client_id"}
        client_secret = ${config.sops.placeholder."rclone/client_secret"}
        token = ${config.sops.placeholder."rclone/access_token"}
      '';
      home.activation."rclone.conf" = ''
        ln -sf ${config.sops.templates."rclone.conf".path} ~/.config/rclone/rclone.conf
      '';
    })
  ];
}
