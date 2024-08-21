{ config, lib, pkgs, inputs, outputs, ... }:

{
  options = {
    localization.enable = lib.mkEnableOption "enables localization settings for Dublin";
  };

  config = lib.mkIf config.localization.enable {
    time.timeZone = lib.mkDefault "Europe/Dublin";
    i18n.defaultLocale = lib.mkDefault "en_IE.UTF-8";
  };
}
