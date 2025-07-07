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
    cosmic-manager.enable = lib.mkEnableOption "cosmic-manager customisations";
  };

  config = lib.mkIf config.cosmic-manager.enable {
    home.packages = with pkgs; [
      inter
      jetbrains-mono
    ];

    wayland.desktopManager.cosmic = {
      enable = true;

      wallpapers = [
        {
          filter_by_theme = true;
          filter_method = cosmicLib.cosmic.mkRON "enum" "Lanczos";
          output = "all";
          rotation_frequency = 300;
          sampling_method = cosmicLib.cosmic.mkRON "enum" "Alphanumeric";
          scaling_mode = cosmicLib.cosmic.mkRON "enum" "Zoom";
          source = cosmicLib.cosmic.mkRON "enum" {
            value = [
              "${pkgs.gruvbox-wallpapers}/wallpapers/irl/forest-2.jpg"
            ];
            variant = "Path";
          };
        }
      ];

      compositor = {
        xkb_config = {
          layout = "gb";
          model = "pc104";
          options = cosmicLib.cosmic.mkRON "optional" "terminate:ctrl_alt_bksp";
          repeat_delay = 600;
          repeat_rate = 25;
          rules = "";
          variant = "extd";
        };
        workspaces = {
          workspace_layout = cosmicLib.cosmic.mkRON "enum" "Vertical";
          workspace_mode = cosmicLib.cosmic.mkRON "enum" "Global";
        };
      };

      shortcuts = [
        {
          action = cosmicLib.cosmic.mkRON "enum" "Minimize";
          key = "Super+Shift+M";
        }
      ];

      applets = {
        audio.settings.show_media_controls_in_top_panel = true;
        time.settings = {
          first_day_of_week = 0; # Monday
          military_time = true;
          show_date_in_top_panel = true;
          show_seconds = false;
          show_weekday = true;
        };
        app-list.settings.favorites =
          [
            "com.system76.cosmicTerm"
            "com.system76.cosmicFiles"
            "com.system76.cosmicStore"
          ]
          ++ (if config.web.brave.enable then [ "Brave-browser" ] else [ ])
          ++ (if config.development.vscode.enable then [ "code" ] else [ ]);
      };

      panels = [
        {
          anchor = cosmicLib.cosmic.mkRON "enum" "Top";
          anchor_gap = true;
          autohide = cosmicLib.cosmic.mkRON "optional" null;
          background = cosmicLib.cosmic.mkRON "enum" "ThemeDefault";
          expand_to_edges = true;
          name = "Panel";
          opacity = 0.8;
          output = cosmicLib.cosmic.mkRON "enum" "All";
          plugins_center = cosmicLib.cosmic.mkRON "optional" [
            "com.system76.CosmicPanelWorkspacesButton"
            "com.system76.CosmicAppletTime"
            "com.system76.CosmicPanelAppButton"
          ];
          plugins_wings = cosmicLib.cosmic.mkRON "optional" (
            cosmicLib.cosmic.mkRON "tuple" [
              [
                "com.system76.CosmicAppletWorkspaces"
                "com.system76.CosmicAppList"
              ]
              [
                "com.system76.CosmicAppletTiling"
                "com.system76.CosmicAppletNotifications"
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

      appearance = {
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
            family = "JetBrains Mono";
            stretch = cosmicLib.cosmic.mkRON "enum" "Normal";
            style = cosmicLib.cosmic.mkRON "enum" "Normal";
            weight = cosmicLib.cosmic.mkRON "enum" "Normal";
          };
        };
      };
    };
  };
}
