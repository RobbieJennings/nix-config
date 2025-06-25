{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    gaming.prism.enable = lib.mkEnableOption "enables prism minecraft launcher";
  };

  config = lib.mkIf config.gaming.prism.enable {
    services.flatpak.packages = [
      {
        appId = "org.prismlauncher.PrismLauncher";
        origin = "flathub";
      }
    ];
  };
}
