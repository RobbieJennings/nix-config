{
  inputs,
  ...
}:
{
  flake.modules.homeManager.brave =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        brave.enable = lib.mkEnableOption "brave web browser";
      };

      config = lib.mkIf config.brave.enable {
        services.flatpak.packages = [
          {
            appId = "com.brave.Browser";
            origin = "flathub";
          }
        ];
      };
    };
}
