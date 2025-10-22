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
