{
  inputs,
  ...
}:
{
  flake.modules.homeManager.plasma-manager-panels =
    {
      pkgs,
      lib,
      config,
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
                  ++ (if config.brave.enable then [ "applications:com.brave.Browser.desktop" ] else [ ])
                  ++ (if config.cursor.enable then [ "applications:cursor.desktop" ] else [ ]);
                };
              }
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.systemmonitor.net"
              "org.kde.plasma.systemmonitor.cpucore"
              "org.kde.plasma.systemmonitor.memory"
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
