{
  inputs,
  ...
}:
{
  flake.modules.homeManager.firefox =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        firefox.enable = lib.mkEnableOption "firefox web browser";
      };

      config = lib.mkIf config.firefox.enable {
        services.flatpak.packages = [
          {
            appId = "org.mozilla.firefox";
            origin = "flathub";
          }
        ];
      };
    };
}
