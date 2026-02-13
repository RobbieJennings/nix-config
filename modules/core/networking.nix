{
  inputs,
  ...
}:
{
  flake.modules.nixos.networking =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        networking.enable = lib.mkEnableOption "networking using networkmanager";
      };

      config = lib.mkIf config.networking.enable {
        networking.networkmanager.enable = true;
      };
    };
}
