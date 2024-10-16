{ config, lib, pkgs, inputs, ... }:

{
  options = {
    desktop-customisations.stylix.enable = lib.mkEnableOption "enables stylix customisations";
  };

  config = lib.mkIf config.desktop-customisations.plasma-manager.enable {
    stylix = {
      enable = true;
      image = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    };
  };
}
