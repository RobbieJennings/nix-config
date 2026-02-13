{
  inputs,
  ...
}:
{
  flake.modules.nixos.localisation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        localisation.enable = lib.mkEnableOption "localisation settings for Dublin";
      };

      config = lib.mkIf config.localisation.enable {
        time.timeZone = lib.mkDefault "Europe/Dublin";
        i18n.defaultLocale = lib.mkDefault "en_IE.UTF-8";
        console.keyMap = lib.mkDefault "ie";
      };
    };
}
