{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    secrets.enable = lib.mkEnableOption "enables importing secrets using sops-nix";
  };

  config = lib.mkIf config.secrets.enable {
    environment.systemPackages = [ pkgs.sops ];
  };
}
