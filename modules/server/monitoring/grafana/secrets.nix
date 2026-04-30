{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.grafana-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf
          (config.monitoring.grafana.enable && config.secrets.enable && config.secrets.grafana.enable)
          {
            sops = {
              secrets = {
                "grafana/username" = { };
                "grafana/password" = { };
              };
              templates.grafanaSecrets = {
                content = builtins.toJSON {
                  apiVersion = "v1";
                  kind = "Secret";
                  type = "Opaque";
                  metadata = {
                    name = "grafana-secrets";
                    namespace = "monitoring";
                  };
                  stringData = {
                    admin-user = config.sops.placeholder."grafana/username";
                    admin-password = config.sops.placeholder."grafana/password";
                  };
                };
                path = "/var/lib/rancher/k3s/server/manifests/grafana-secret.json";
              };
            };
          };
    };
}
