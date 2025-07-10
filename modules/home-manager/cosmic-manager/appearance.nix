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

  config = lib.mkIf config.cosmic-manager.appearance.enable {
    wayland.desktopManager.cosmic.appearance = {
      theme = {
        mode = "dark";
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
          accent = cosmicLib.cosmic.mkRON "optional" {
            red = 0.7921569;
            green = 0.7294118;
            blue = 0.7058824;
          };
        };
        light = {
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
          accent = cosmicLib.cosmic.mkRON "optional" {
            red = 0.33333334;
            green = 0.2784314;
            blue = 0.25882354;
          };
        };
      };
      toolkit = {
        apply_theme_global = true;
        interface_font = {
          family = "Inter";
          stretch = cosmicLib.cosmic.mkRON "enum" "Normal";
          style = cosmicLib.cosmic.mkRON "enum" "Normal";
          weight = cosmicLib.cosmic.mkRON "enum" "Normal";
        };
        monospace_font = {
          family = "JetBrainsMono Nerd Font Mono";
          stretch = cosmicLib.cosmic.mkRON "enum" "Normal";
          style = cosmicLib.cosmic.mkRON "enum" "Normal";
          weight = cosmicLib.cosmic.mkRON "enum" "Normal";
        };
      };
    };
  };
}
