{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    plasma-manager.look-and-feel.enable = lib.mkEnableOption "plasma-manager look and feel customisations";
  };

  config = lib.mkIf config.plasma-manager.look-and-feel.enable {
    programs.plasma = {
      workspace.lookAndFeel = "org.kde.breezedark.desktop";
      kwin.effects.translucency.enable = true;
      fonts = {
        fixedWidth = {
          family = "JetBrainsMono Nerd Font Mono";
          pointSize = 10;
        };
      };
    };
  };
}
