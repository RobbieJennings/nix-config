{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.freshrss-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.secrets.freshrss = {
        enable = lib.mkEnableOption "FreshRSS login secrets";
      };

      config =
        lib.mkIf (config.freshrss.enable && config.secrets.enable && config.secrets.freshrss.enable)
          {
            sops.secrets = {
              "freshrss/username" = { };
              "freshrss/password" = { };
            };
          };
    };
}
