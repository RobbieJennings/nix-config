{ config, lib, pkgs, inputs, ... }:

{
  options = {
    desktop-customisations.plasma-manager.enable = lib.mkEnableOption "enables plasma-manager customisations";
  };

  config = lib.mkIf config.desktop-customisations.plasma-manager.enable {
    programs.plasma = {
      enable = true;
      input.keyboard.layouts = [ { layout = "ie"; } ];
      kwin = {
        effects = {
          translucency.enable = true;
        };
      };
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
                ]
                ++ (if config.web.brave.enable then ["applications:com.brave.Browser.desktop"] else []);
              };
            }
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.systemmonitor.cpucore"
            {
              systemMonitor = {
                title = "CPU TEMP";
                displayStyle = "org.kde.ksysguard.piechart";
                sensors = [{
                  name = "cpu/all/averageTemperature";
                  color = "180 190 254";
                  label = "CPU TEMP";
                }];
                totalSensors = ["cpu/all/averageTemperature"];
              };
            }
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
                title = "NETWORK USAGE";
                displayStyle = "org.kde.ksysguard.horizontalbars";
                sensors = [
                  {
                    name = "network/all/download";
                    color = "180 190 254";
                    label = "DOWNLOAD";
                  }
                  {
                    name = "network/all/upload";
                    color = "180 190 254";
                    label = "UPLOAD";
                  }
                ];
                totalSensors = [
                  "network/all/download"
                  "network/all/upload"
                ];
              };
            }
            {
              systemTray.items = {
                shown = [
                  "org.kde.plasma.brightness"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.volume"
                  "org.kde.plasma.battery"
                ];
                hidden = [];
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
