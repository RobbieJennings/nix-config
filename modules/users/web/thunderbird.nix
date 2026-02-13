{
  inputs,
  ...
}:
{
  flake.modules.homeManager.thunderbird =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        thunderbird.enable = lib.mkEnableOption "thunderbird email client";
      };

      config = lib.mkIf config.thunderbird.enable {
        services.flatpak.packages = [
          {
            appId = "org.mozilla.Thunderbird";
            origin = "flathub";
          }
        ];
      };
    };
}
