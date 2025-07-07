{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    plasma-manager.wallpaper.enable = lib.mkEnableOption "plasma-manager wallpaper customisations";
  };

  config = lib.mkIf config.plasma-manager.wallpaper.enable {
    programs.plasma = {
      kscreenlocker.appearance.wallpaper = "${pkgs.gruvbox-wallpapers}/wallpapers/irl/forest-2.jpg";
      workspace.wallpaper = "${pkgs.gruvbox-wallpapers}/wallpapers/irl/forest-2.jpg";
    };
  };
}
