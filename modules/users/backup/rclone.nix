{
  inputs,
  ...
}:
{
  flake.modules.homeManager.rclone =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        rclone.enable = lib.mkEnableOption "rclone google drive remote";
        secrets.rclone.enable = lib.mkEnableOption "rclone google drive secrets";
      };

      config = lib.mkMerge [
        (lib.mkIf config.rclone.enable {
          programs.rclone.enable = true;
        })

        (lib.mkIf (config.rclone.enable && config.secrets.enable && config.secrets.rclone.enable) {
          sops = {
            secrets = {
              "restic/repository" = { };
              "restic/password" = { };
              "rclone/client_id" = { };
              "rclone/client_secret" = { };
              "rclone/access_token" = { };
            };
            templates."rclone.conf".content = ''
              [gdrive]
              scope = drive.file
              type = drive
              client_id = ${config.sops.placeholder."rclone/client_id"}
              client_secret = ${config.sops.placeholder."rclone/client_secret"}
              token = ${config.sops.placeholder."rclone/access_token"}
            '';
          };
          home.activation."rclone.conf" = ''
            mkdir -p ~/.config/rclone
            ln -sf ${config.sops.templates."rclone.conf".path} ~/.config/rclone/rclone.conf
          '';
        })
      ];
    };
}
