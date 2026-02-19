{
  inputs,
  ...
}:
{
  flake.modules.nixos.k3s =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        k3s.enable = lib.mkEnableOption "k3s";
        secrets.k3s.enable = lib.mkEnableOption "k3s token secret";
      };

      config = lib.mkMerge [
        (lib.mkIf config.k3s.enable {
          services.k3s = {
            enable = true;
            images = [ config.services.k3s.package.airgap-images ];
            extraFlags = [
              "--embedded-registry"
              "--disable servicelb"
              "--disable traefik"
              "--disable local-storage"
              "--disable metrics-server"
            ];
          };
        })
        (lib.mkIf (config.k3s.enable && config.secrets.enable && config.secrets.k3s.enable) {
          sops.secrets."k3s/token" = { };
          services.k3s.tokenFile = config.sops.secrets."k3s/token".path;
        })
      ];
    };
}
