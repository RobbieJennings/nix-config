{
  inputs,
  ...
}:
{
  flake.modules.homeManager.heroic =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        heroic.enable = lib.mkEnableOption "heroic games launcher";
      };

      config = lib.mkIf config.heroic.enable {
        services.flatpak.packages = [
          {
            appId = "com.heroicgameslauncher.hgl";
            origin = "flathub";
          }
        ];
      };
    };
}
