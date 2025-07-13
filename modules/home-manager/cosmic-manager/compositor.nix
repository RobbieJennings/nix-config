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
    cosmic-manager.compositor.enable = lib.mkEnableOption "cosmic-manager compositor customisations";
  };

  config = lib.mkIf config.cosmic-manager.compositor.enable {
    wayland.desktopManager.cosmic.compositor = {
      workspaces = {
        workspace_layout = cosmicLib.cosmic.mkRON "enum" "Vertical";
        workspace_mode = cosmicLib.cosmic.mkRON "enum" "OutputBound";
      };
      xkb_config = {
        layout = "gb";
        model = "pc104";
        options = cosmicLib.cosmic.mkRON "optional" "terminate:ctrl_alt_bksp";
        repeat_delay = 600;
        repeat_rate = 25;
        rules = "";
        variant = "extd";
      };
      input_touchpad = {
        scroll_config = cosmicLib.cosmic.mkRON "optional" {
          method = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "TwoFinger");
          natural_scroll = cosmicLib.cosmic.mkRON "optional" true;
          scroll_button = cosmicLib.cosmic.mkRON "optional" 2;
          scroll_factor = cosmicLib.cosmic.mkRON "optional" 1.0;
        };
        tap_config = cosmicLib.cosmic.mkRON "optional" {
          enabled = true;
          drag = true;
          drag_lock = true;
          button_map = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "LeftMiddleRight");
        };
      };
    };
  };
}
