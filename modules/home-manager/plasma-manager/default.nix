{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    plasma-manager.enable = lib.mkEnableOption "plasma-manager customisations";
  };

  config = lib.mkIf config.plasma-manager.enable {
    programs.plasma = {
      enable = true;
      input.keyboard.layouts = lib.mkDefault [ { layout = "ie"; } ];
      kscreenlocker.appearance.wallpaper = lib.mkDefault "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";
      workspace.wallpaper = lib.mkDefault "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";
      workspace.lookAndFeel = lib.mkDefault "org.kde.breezedark.desktop";
      kwin.effects.translucency.enable = lib.mkDefault true;

      panels = lib.mkDefault [
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
                ] ++ (if config.web.brave.enable then [ "applications:com.brave.Browser.desktop" ] else [ ]);
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
  };
}
