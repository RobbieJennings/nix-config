{ config, lib, pkgs, inputs, ... }:

{
  options = {
    desktop-customisations.plasma-manager.enable = lib.mkEnableOption "enables plasma-manager customisations";
  };

  config = lib.mkIf config.desktop-customisations.plasma-manager.enable {
    programs.plasma = {
      enable = true;
      panels = [
        {
          location = "bottom";
          floating = true;
          widgets = [
            {
              kickoff = {
                icon = "nix-snowflake-white";
              };
            }
            "org.kde.plasma.pager"
            {
              iconTasks = {
                launchers = [
                  "applications:systemsettings.desktop"
                  "applications:org.kde.konsole.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:org.kde.kate.desktop"
                  "applications:com.brave.Browser.desktop"
                ];
              };
            }
            "org.kde.plasma.marginsseparator"
            {
            systemTray.items = {
                shown = [
                  "org.kde.plasma.brightness"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.volume"
                ];
                hidden = [
                  "org.kde.plasma.battery"
                ];
              };
            }
            {
              digitalClock = {
                calendar.firstDayOfWeek = "monday";
                time.format = "24h";
              };
            }
            "org.kde.plasma.showdesktop"
          ];
        }
      ];
    };
  };
}
