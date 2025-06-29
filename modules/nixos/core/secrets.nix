{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    secrets.enable = lib.mkEnableOption "importing secrets using sops-nix";
  };

  config = lib.mkIf config.secrets.enable {
    environment.systemPackages = [
      pkgs.sops
      pkgs.ssh-to-age
    ];
  };
}
