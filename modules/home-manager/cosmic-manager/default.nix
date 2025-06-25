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
    cosmic-manager.enable = lib.mkEnableOption "enables cosmic-manager customisations";
  };

  config = lib.mkIf config.cosmic-manager.enable {
    wayland.desktopManager.cosmic.enable = true;
    programs.cosmic-ext-calculator.enable = lib.mkDefault true;

    wayland.desktopManager.cosmic.applets = {
      audio.settings.show_media_controls_in_top_panel = false;
      time.settings = {
        first_day_of_week = 7; # Monday
        military_time = true;
        show_date_in_top_panel = true;
        show_seconds = false;
        show_weekday = true;
      };
    };

    wayland.desktopManager.cosmic.panels = [
      {
        anchor = cosmicLib.cosmic.mkRON "enum" "Top";
        anchor_gap = true;
        autohide = cosmicLib.cosmic.mkRON "optional" null;
        background = cosmicLib.cosmic.mkRON "enum" "ThemeDefault";
        expand_to_edges = true;
        name = "Panel";
        opacity = 0.8;
        output = cosmicLib.cosmic.mkRON "enum" "All";
        plugins_center = cosmicLib.cosmic.mkRON "optional" [ "com.system76.CosmicAppletTime" ];
        plugins_wings = cosmicLib.cosmic.mkRON "optional" (
          cosmicLib.cosmic.mkRON "tuple" [
            [
              "com.system76.CosmicAppletWorkspaces"
              "com.system76.CosmicAppList"
            ]
            [
              "com.system76.CosmicAppletTiling"
              "com.system76.CosmicAppletNotifications"
              "com.system76.CosmicAppletAudio"
              "com.system76.CosmicAppletBluetooth"
              "com.system76.CosmicAppletNetwork"
              "com.system76.CosmicAppletBattery"
              "com.system76.CosmicAppletPower"
            ]
          ]
        );
        size = cosmicLib.cosmic.mkRON "enum" "S";
      }
    ];

    home.packages = with pkgs; [
      inter
      jetbrains-mono
    ];

    wayland.desktopManager.cosmic.appearance = {
      toolkit = {
        apply_theme_global = true;
        interface_font = {
          family = "Inter";
          stretch = cosmicLib.cosmic.mkRON "enum" "Normal";
          style = cosmicLib.cosmic.mkRON "enum" "Normal";
          weight = cosmicLib.cosmic.mkRON "enum" "Normal";
        };
        monospace_font = {
          family = "JetBrains Mono";
          stretch = cosmicLib.cosmic.mkRON "enum" "Normal";
          style = cosmicLib.cosmic.mkRON "enum" "Normal";
          weight = cosmicLib.cosmic.mkRON "enum" "Normal";
        };
      };
    };
  };
}
