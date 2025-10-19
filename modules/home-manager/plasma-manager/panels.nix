{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    plasma-manager.panels.enable = lib.mkEnableOption "plasma-manager panel customisations";
  };

  config = lib.mkIf config.plasma-manager.panels.enable {
    programs.plasma.panels = [
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
                "applications:org.kde.discover.desktop"
              ]
              ++ (if config.web.brave.enable then [ "applications:com.brave.Browser.desktop" ] else [ ])
              ++ (
                if config.development.vscode.enable then [ "applications:codium-url-handler.desktop" ] else [ ]
              );
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemmonitor.net"
          "org.kde.plasma.systemmonitor.cpucore"
          {
            systemMonitor = {
              title = "MEMORY USAGE";
              displayStyle = "org.kde.ksysguard.horizontalbars";
              sensors = [
                {
                  name = "memory/physical/usedPercent";
                  color = "180 190 254";
                  label = "RAM USAGE";
                }
                {
                  name = "memory/swap/usedPercent";
                  color = "180 190 254";
                  label = "SWAP USAGE";
                }
              ];
              totalSensors = [
                "memory/physical/userPercent"
                "memory/swap/usedPercent"
              ];
            };
          }
          {
            systemMonitor = {
              title = "CPU TEMP";
              displayStyle = "org.kde.ksysguard.piechart";
              sensors = [
                {
                  name = "cpu/all/averageTemperature";
                  color = "180 190 254";
                  label = "CPU TEMP";
                }
              ];
              totalSensors = [ "cpu/all/averageTemperature" ];
              range.from = 0;
              range.to = 100;
            };
          }
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
                "org.kde.plasma.battery"
                "org.kde.plasma.brightness"
                "org.kde.plasma.bluetooth"
              ];
              hidden = [ ];
              configs = {
                battery.showPercentage = true;
              };
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
}
