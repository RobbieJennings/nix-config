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
    cosmic-manager.panels.enable = lib.mkEnableOption "cosmic-manager panels customisations";
  };

  config = lib.mkIf config.cosmic-manager.panels.enable {
    wayland.desktopManager.cosmic.panels = [
      {
        anchor = cosmicLib.cosmic.mkRON "enum" "Top";
        anchor_gap = true;
        autohide = cosmicLib.cosmic.mkRON "optional" null;
        background = cosmicLib.cosmic.mkRON "enum" "ThemeDefault";
        expand_to_edges = true;
        margin = 2;
        name = "Panel";
        opacity = 0.8;
        output = cosmicLib.cosmic.mkRON "enum" "All";
        plugins_center = cosmicLib.cosmic.mkRON "optional" [
          "com.system76.CosmicAppletTime"
        ];
        plugins_wings = cosmicLib.cosmic.mkRON "optional" (
          cosmicLib.cosmic.mkRON "tuple" [
            [
              "com.system76.CosmicAppletWorkspaces"
              "com.system76.CosmicPanelAppButton"
              "com.system76.CosmicAppList"
            ]
            [
              "com.system76.CosmicAppletStatusArea"
              "com.system76.CosmicAppletNotifications"
              "com.system76.CosmicAppletTiling"
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
  };
}
