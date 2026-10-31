{
  inputs,
  ...
}:
{
  flake.modules.nixos.resource-profiles =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      mkProfile = reqCpu: reqMem: limCpu: limMem: {
        requests.cpu = reqCpu;
        requests.memory = reqMem;
        limits.cpu = limCpu;
        limits.memory = limMem;
      };
      resourceProfiles = {
        appMini = mkProfile "10m" "64Mi" "500m" "256Mi";
        appSmall = mkProfile "20m" "128Mi" "1000m" "512Mi";
        appMedium = mkProfile "50m" "256Mi" "2000m" "1Gi";
        appLarge = mkProfile "100m" "512Mi" "2000m" "2Gi";
        cache = mkProfile "10m" "64Mi" "200m" "256Mi";
        dbSmall = mkProfile "20m" "128Mi" "1000m" "512Mi";
        dbMedium = mkProfile "50m" "256Mi" "2000m" "2Gi";
        infraMini = mkProfile "5m" "32Mi" "200m" "128Mi";
        infraSmall = mkProfile "10m" "32Mi" "200m" "128Mi";
        infraMedium = mkProfile "20m" "48Mi" "500m" "256Mi";
        infraLarge = mkProfile "25m" "64Mi" "500m" "256Mi";
      };
    in
    {
      options.server.resources.profiles = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              requests = {
                cpu = lib.mkOption {
                  type = lib.types.str;
                  description = "Requested CPU core percentage";
                };
                memory = lib.mkOption {
                  type = lib.types.str;
                  description = "Requested memory";
                };
              };
              limits = {
                cpu = lib.mkOption {
                  type = lib.types.str;
                  description = "CPU core percentage limit";
                };
                memory = lib.mkOption {
                  type = lib.types.str;
                  description = "Memory limit";
                };
              };
            };
          }
        );
        default = resourceProfiles;
        description = "Kubernetes resource profiles";
      };
    };
}
