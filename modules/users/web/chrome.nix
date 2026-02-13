{
  inputs,
  ...
}:
{
  flake.modules.homeManager.chrome =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        chrome.enable = lib.mkEnableOption "chrome web browser";
      };

      config = lib.mkIf config.chrome.enable {
        services.flatpak.packages = [
          {
            appId = "com.google.Chrome";
            origin = "flathub";
          }
        ];
      };
    };
}
