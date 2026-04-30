{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.netbird-operator-router =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.netbird-operator.enable {
        services.k3s.autoDeployCharts.netbird-operator.extraDeploy = [
          {
            apiVersion = "netbird.io/v1alpha1";
            kind = "NetworkRouter";
            metadata = {
              name = "homelab";
              namespace = "netbird";
            };
            spec = {
              dnsZoneRef.name = "homelab";
              workloadOverride = {
                replicas = 1;
                podTemplate.spec = {
                  dnsConfig.options = [
                    {
                      name = "ndots";
                      value = "0";
                    }
                  ];
                  resources = {
                    requests.cpu = "100m";
                    requests.memory = "128Mi";
                    limits.cpu = "250m";
                    limits.memory = "256Mi";
                  };
                };
              };
            };
          }
        ];
      };
    };
}
