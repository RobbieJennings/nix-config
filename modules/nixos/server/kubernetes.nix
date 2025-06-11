{ config, lib, pkgs, inputs, ... }:

{
  options = { server.kubernetes.enable = lib.mkEnableOption "enables k3s"; };

  config = lib.mkIf config.server.kubernetes.enable {
    services.k3s = {
      enable = true;
      tokenFile = config.sops.secrets.k3s-token.path;
      images = [ config.services.k3s.package.airgapImages ];
      extraFlags = [ "--embedded-registry" "--disable metrics-server" ];
    };
  };
}
