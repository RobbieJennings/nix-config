{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.garage-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.garage.enable && config.secrets.enable && config.secrets.garage.enable) {
        sops = {
          secrets = {
            "garage/API_ADMIN_KEY" = { };
          };
          templates = {
            garage-web-ui-secrets = {
              content = builtins.toJSON {
                apiVersion = "v1";
                kind = "Secret";
                metadata = {
                  name = "garage-web-ui-secrets";
                  namespace = "garage";
                };
                type = "Opaque";
                stringData = {
                  API_ADMIN_KEY = config.sops.placeholder."garage/API_ADMIN_KEY";
                };
              };
              path = "/var/lib/rancher/k3s/server/manifests/garage-web-ui-secrets.json";
            };
          };
        };
      };
    };
}
