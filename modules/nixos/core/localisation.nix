{ config, lib, pkgs, inputs, ... }:

{
  options = {
    localisation.enable = lib.mkEnableOption "enables localisation settings for Dublin";
  };

  config = lib.mkIf config.localisation.enable {
    time.timeZone = lib.mkDefault "Europe/Dublin";
    i18n.defaultLocale = lib.mkDefault "en_IE.UTF-8";
  };
}
