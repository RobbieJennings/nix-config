{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    web.thunderbird.enable = lib.mkEnableOption "thunderbird email client";
  };

  config = lib.mkIf config.web.thunderbird.enable {
    services.flatpak.packages = [
      {
        appId = "org.mozilla.Thunderbird";
        origin = "flathub";
      }
    ];
  };
}
