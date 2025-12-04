{
  config,
  lib,
  pkgs,
  inputs,
  cosmicLib,
  ...
}:

{
  options = {
    cosmic-manager.applets.enable = lib.mkEnableOption "cosmic-manager applets customisations";
  };

  config = lib.mkIf config.cosmic-manager.applets.enable {
    home.packages = [
      pkgs.cosmic-ext-applet-privacy-indicator
      pkgs.cosmic-ext-applet-minimon
      pkgs.cosmic-ext-applet-caffeine
      pkgs.cosmic-ext-applet-clipboard-manager
    ];
    wayland.desktopManager.cosmic.applets = {
      audio.settings.show_media_controls_in_top_panel = true;
      time.settings = {
        first_day_of_week = 0;
        military_time = true;
        show_date_in_top_panel = true;
        show_seconds = false;
        show_weekday = true;
      };
      app-list.settings.favorites = [
        "com.system76.cosmicTerm"
        "com.system76.cosmicFiles"
        "com.system76.cosmicStore"
      ]
      ++ (if config.web.brave.enable then [ "Brave-browser" ] else [ ])
      ++ (if config.development.vscode.enable then [ "codium-url-handler" ] else [ ]);
    };
  };
}
