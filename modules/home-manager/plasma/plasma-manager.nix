{ config, lib, pkgs, inputs, ... }:

{
  options = {
    plasma.plasma-manager.enable = lib.mkEnableOption "enables plasma-manager tweaks";
  };

  config = lib.mkIf config.plasma.plasma-manager.enable {
    programs.plasma = {
      enable = true;
      workspace = {
        wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";
      };
    };
  };
}
