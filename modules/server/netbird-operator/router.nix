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
      options.netbird-operator = {
        routerResources = lib.mkOption {
          type = inputs.self.lib.types.resourceProfile;
          default = config.server.resources.profiles.infraLarge;
          description = "Resource profile for Netbird Router";
        };
      };

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
                  containers = [ { name = "netbird"; } ];
                  resources = config.netbird-operator.routerResources;
                };
              };
            };
          }
        ];
      };
    };
}
