{
  inputs,
  ...
}:
{
  flake.modules.nixos.tailscale =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        tailscale.enable = lib.mkEnableOption "tailscale client daemon";
      };

      config = lib.mkIf config.tailscale.enable {
        services.resolved.enable = true;
        services.tailscale.enable = true;
      };
    };
}
