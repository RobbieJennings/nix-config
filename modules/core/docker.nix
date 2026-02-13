{
  inputs,
  ...
}:
{
  flake.modules.nixos.docker =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        docker.enable = lib.mkEnableOption "docker";
      };

      config = lib.mkIf config.docker.enable {
        virtualisation.docker.enable = true;
      };
    };
}
