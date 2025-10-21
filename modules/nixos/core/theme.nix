{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    theme = {
      enable = lib.mkEnableOption "stylix theme";

      base16Scheme = lib.mkOption {
        type = lib.types.str;
        default = "default-dark";
        description = "yaml filename of base16 colour scheme found in pkgs.base16-schemse/share/themes";
        example = "catppuccin-mocha";
      };

      image = lib.mkOption {
        type = lib.types.submodule {
          options = {
            url = lib.mkOption {
              type = lib.types.str;
              description = "Download URL";
            };
            hash = lib.mkOption {
              type = lib.types.str;
              description = "SHA256 hash in SRI format";
            };
          };
        };
        default = {
          url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-simple-dark-gray.png";
          hash = "sha256-JaLHdBxwrphKVherDVe5fgh+3zqUtpcwuNbjwrBlAok=";
        };
        description = "Custom source with URL and hash";
      };

      fonts = lib.mkOption {
        type = lib.types.submodule {
          options = {
            interface = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  package = lib.mkOption {
                    type = lib.types.package;
                    description = "package to use for the interface font";
                  };
                  name = lib.mkOption {
                    type = lib.types.str;
                    description = "The name to use for the interface font";
                  };
                };
              };
              default = {
                package = pkgs.inter;
                name = "Inter";
              };
              defaultText = lib.literalExpression "Inter";
              description = "The font to use for the interface";
            };
            monospace = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  package = lib.mkOption {
                    type = lib.types.package;
                    description = "package to use for the monospace font";
                  };
                  name = lib.mkOption {
                    type = lib.types.str;
                    description = "The name to use for the monospace font";
                  };
                };
              };
              default = {
                package = pkgs.nerd-fonts.jetbrains-mono;
                name = "Nerd Font Jetbrains Mono";
              };
              defaultText = lib.literalExpression "Nerd Font Jetbrains Mono";
              description = "The font to use for the terminal";
            };
            emoji = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  package = lib.mkOption {
                    type = lib.types.package;
                    description = "package to use for the emoji font";
                  };
                  name = lib.mkOption {
                    type = lib.types.str;
                    description = "The name to use for the emoji font";
                  };
                };
              };
              default = {
                package = pkgs.noto-fonts-emoji;
                name = "Noto Color Emoji";
              };
              defaultText = lib.literalExpression "Noto Color Emoji";
              description = "The font to use for emoji";
            };
          };
        };
        default = { };
        description = "Fonts used for interface, terminal and emojis";
      };
    };
  };

  config = lib.mkIf config.theme.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.theme.base16Scheme}.yaml";
      image = pkgs.fetchurl config.theme.image;
      fonts = {
        serif = config.theme.fonts.interface;
        sansSerif = config.theme.fonts.interface;
        inherit (config.theme.fonts.monospace) ;
        inherit (config.theme.fonts.emoji) ;
      };
    };
  };
}
