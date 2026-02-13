{
  inputs,
  ...
}:
{
  flake.modules.homeManager.prism =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        prism.enable = lib.mkEnableOption "prism minecraft launcher";
      };

      config = lib.mkIf config.prism.enable {
        services.flatpak.packages = [
          {
            appId = "org.prismlauncher.PrismLauncher";
            origin = "flathub";
          }
        ];
      };
    };
}
