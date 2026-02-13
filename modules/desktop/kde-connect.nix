{
  inputs,
  ...
}:
{
  flake.modules.nixos.kde-connect =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        kde-connect.enable = lib.mkEnableOption "kde connect phone pairing app";
      };

      config = lib.mkIf config.kde-connect.enable {
        programs.kdeconnect.enable = true;
      };
    };
}
