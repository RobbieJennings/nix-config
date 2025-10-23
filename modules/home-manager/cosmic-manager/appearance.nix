{
  config,
  lib,
  pkgs,
  inputs,
  cosmicLib,
  ...
}:

let
  stylix2Cosmic =
    color:
    cosmicLib.cosmic.mkRON "optional" {
      blue = builtins.fromJSON config.lib.stylix.colors."${color}-dec-b";
      green = builtins.fromJSON config.lib.stylix.colors."${color}-dec-g";
      red = builtins.fromJSON config.lib.stylix.colors."${color}-dec-r";
    };

  stylix2CosmicAlpha =
    color: alpha:
    cosmicLib.cosmic.mkRON "optional" {
      blue = builtins.fromJSON config.lib.stylix.colors."${color}-dec-b";
      green = builtins.fromJSON config.lib.stylix.colors."${color}-dec-g";
      red = builtins.fromJSON config.lib.stylix.colors."${color}-dec-r";
      inherit alpha;
    };

  stylix2PaletteAlpha = color: alpha: {
    blue = builtins.fromJSON config.lib.stylix.colors."${color}-dec-b";
    green = builtins.fromJSON config.lib.stylix.colors."${color}-dec-g";
    red = builtins.fromJSON config.lib.stylix.colors."${color}-dec-r";
    inherit alpha;
  };
in
{
  options = {
    cosmic-manager.appearance.enable = lib.mkEnableOption "cosmic-manager appearance customisations";
  };

  config = lib.mkMerge [
    (lib.mkIf config.cosmic-manager.appearance.enable {
      wayland.desktopManager.cosmic.appearance = {
        theme = {
          dark = {
            active_hint = 2;
            gaps = cosmicLib.cosmic.mkRON "tuple" [
              0
              4
            ];
            corner_radii = {
              radius_0 = cosmicLib.cosmic.mkRON "tuple" [
                0.0
                0.0
                0.0
                0.0
              ];
              radius_xs = cosmicLib.cosmic.mkRON "tuple" [
                2.0
                2.0
                2.0
                2.0
              ];
              radius_s = cosmicLib.cosmic.mkRON "tuple" [
                8.0
                8.0
                8.0
                8.0
              ];
              radius_m = cosmicLib.cosmic.mkRON "tuple" [
                8.0
                8.0
                8.0
                8.0
              ];
              radius_l = cosmicLib.cosmic.mkRON "tuple" [
                8.0
                8.0
                8.0
                8.0
              ];
              radius_xl = cosmicLib.cosmic.mkRON "tuple" [
                8.0
                8.0
                8.0
                8.0
              ];
            };
          };
          light = {
            inherit (config.wayland.desktopManager.cosmic.appearance.theme.dark.active_hint) ;
            inherit (config.wayland.desktopManager.cosmic.appearance.theme.dark.gaps) ;
            inherit (config.wayland.desktopManager.cosmic.appearance.theme.dark.corner_radii) ;
          };
        };
      };
    })

    (lib.mkIf (config.cosmic-manager.appearance.enable && config.theme.enable) {
      wayland.desktopManager.cosmic.appearance = {
        theme = {
          mode = "${config.theme.polarity}";
          "${config.theme.polarity}" = {
            accent = stylix2Cosmic "base04";
            windowHint = stylix2Cosmic "base04";
            neutral_tint = stylix2Cosmic "base02";
            text_tint = stylix2Cosmic "base05";
            success = stylix2Cosmic "base0B";
            warning = stylix2Cosmic "base0A";
            destructive = stylix2Cosmic "base08";
            bg_color = stylix2CosmicAlpha "base00" 1.0;
            primary_container_bg = stylix2CosmicAlpha "base01" 1.0;
            secondary_container_bg = stylix2CosmicAlpha "base02" 1.0;
            palette = cosmicLib.cosmic.mkRON "enum" {
              value = [
                {
                  name = "stylix";
                  accent_blue = stylix2PaletteAlpha "base0D" 1.0;
                  accent_green = stylix2PaletteAlpha "base0B" 1.0;
                  accent_indigo = stylix2PaletteAlpha "base0E" 1.0;
                  accent_orange = stylix2PaletteAlpha "base0A" 1.0;
                  accent_pink = stylix2PaletteAlpha "base0E" 1.0;
                  accent_purple = stylix2PaletteAlpha "base0E" 1.0;
                  accent_red = stylix2PaletteAlpha "base08" 1.0;
                  accent_warm_grey = stylix2PaletteAlpha "base04" 1.0;
                  accent_yellow = stylix2PaletteAlpha "base09" 1.0;
                  bright_green = stylix2PaletteAlpha "base0B" 1.0;
                  bright_orange = stylix2PaletteAlpha "base0A" 1.0;
                  bright_red = stylix2PaletteAlpha "base08" 1.0;
                  ext_blue = stylix2PaletteAlpha "base0D" 1.0;
                  ext_indigo = stylix2PaletteAlpha "base0E" 1.0;
                  ext_orange = stylix2PaletteAlpha "base0A" 1.0;
                  ext_pink = stylix2PaletteAlpha "base0E" 1.0;
                  ext_purple = stylix2PaletteAlpha "base0E" 1.0;
                  ext_warm_grey = stylix2PaletteAlpha "base04" 1.0;
                  ext_yellow = stylix2PaletteAlpha "base09" 1.0;
                  gray_1 = stylix2PaletteAlpha "base01" 1.0;
                  gray_2 = stylix2PaletteAlpha "base02" 1.0;
                  neutral_0 = stylix2PaletteAlpha "base00" 1.0;
                  neutral_1 = stylix2PaletteAlpha "base01" 1.0;
                  neutral_2 = stylix2PaletteAlpha "base02" 1.0;
                  neutral_3 = stylix2PaletteAlpha "base03" 1.0;
                  neutral_4 = stylix2PaletteAlpha "base04" 1.0;
                  neutral_5 = stylix2PaletteAlpha "base05" 1.0;
                  neutral_6 = stylix2PaletteAlpha "base06" 1.0;
                  neutral_7 = stylix2PaletteAlpha "base07" 1.0;
                  neutral_8 = stylix2PaletteAlpha "base06" 1.0;
                  neutral_9 = stylix2PaletteAlpha "base07" 1.0;
                  neutral_10 = stylix2PaletteAlpha "base07" 1.0;
                }
              ];
              variant = if config.theme.polarity == "light" then "Light" else "Dark";
            };
          };
        };
        toolkit = {
          apply_theme_global = true;
          interface_font = {
            family = config.theme.fonts.interface.name;
            stretch = cosmicLib.cosmic.mkRON "enum" "Normal";
            style = cosmicLib.cosmic.mkRON "enum" "Normal";
            weight = cosmicLib.cosmic.mkRON "enum" "Normal";
          };
          monospace_font = {
            family = config.theme.fonts.monospace.name;
            stretch = cosmicLib.cosmic.mkRON "enum" "Normal";
            style = cosmicLib.cosmic.mkRON "enum" "Normal";
            weight = cosmicLib.cosmic.mkRON "enum" "Normal";
          };
        };
      };
    })
  ];
}
