{ config, lib, pkgs, inputs, ... }:

{
  disabledModules = [ "${inputs.nixpkgs}/nixos/modules/services/cluster/k3s/default.nix" ];
  imports = [ "${inputs.nixpkgs-unstable}/nixos/modules/services/cluster/k3s/default.nix" ];

  options = {
    server.kubernetes.enable =
      lib.mkEnableOption "enables k3s";
  };

  config = lib.mkIf config.server.kubernetes.enable {
    services.k3s = {
      enable = true;
      tokenFile = config.sops.secrets.k3s-token.path;
      images = [ config.services.k3s.package.airgapImages ];
      extraFlags = [
        "--embedded-registry"
        "--disable metrics-server"
      ];
    };
  };
}
