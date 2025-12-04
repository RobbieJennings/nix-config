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
    home.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";
    services.flatpak = {
      remotes = [
        {
          name = "cosmic-flatpak";
          location = "https://apt.pop-os.org/cosmic/cosmic.flatpakrepo";
        }
      ];
      packages = [
        {
          appId = "io.github.cosmic_utils.cosmic-ext-applet-clipboard-manager";
          origin = "cosmic-flatpak";
        }
        {
          appId = "io.github.cosmic_utils.minimon-applet";
          origin = "cosmic-flatpak";
        }
      ];
    };
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
