{
  inputs,
  ...
}:
{
  flake.modules.homeManager.lutris =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        lutris.enable = lib.mkEnableOption "lutris games launcher";
      };

      config = lib.mkIf config.lutris.enable {
        services.flatpak.packages = [
          {
            appId = "net.lutris.Lutris";
            origin = "flathub";
          }
        ];
      };
    };
}
