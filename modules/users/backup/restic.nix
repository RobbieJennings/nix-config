{
  inputs,
  ...
}:
{
  flake.modules.homeManager.restic =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        restic.enable = lib.mkEnableOption "restic backups";
        secrets.restic.enable = lib.mkEnableOption "restic repository secrets";
      };

      config = lib.mkMerge [
        (lib.mkIf config.restic.enable {
          home.packages = with pkgs; [
            restic
            restic-browser
          ];
        })

        (lib.mkIf (config.restic.enable && config.secrets.enable && config.secrets.restic.enable) {
          sops = {
            secrets = {
              "restic/repository" = { };
              "restic/password" = { };
              "restic/aws_access_key" = { };
              "restic/aws_secret_key" = { };
            };
            templates = {
              "restic/environment".content = ''
                AWS_ACCESS_KEY_ID=${config.sops.placeholder."restic/aws_access_key"}
                AWS_SECRET_ACCESS_KEY=${config.sops.placeholder."restic/aws_secret_key"}
              '';
            };
          };
          services.restic = {
            enable = true;
            backups.daily = {
              repositoryFile = config.sops.secrets."restic/repository".path;
              passwordFile = config.sops.secrets."restic/password".path;
              environmentFile = config.sops.templates."restic/environment".path;
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
    };
}
