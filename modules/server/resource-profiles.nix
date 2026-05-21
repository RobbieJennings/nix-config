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
        appMini = mkProfile "50m" "128Mi" "250m" "256Mi";
        appSmall = mkProfile "100m" "256Mi" "500m" "512Mi";
        appMedium = mkProfile "200m" "512Mi" "1000m" "1Gi";
        appLarge = mkProfile "400m" "1Gi" "2000m" "2Gi";
        cache = mkProfile "20m" "64Mi" "100m" "128Mi";
        dbSmall = mkProfile "100m" "256Mi" "500m" "512Mi";
        dbMedium = mkProfile "200m" "512Mi" "1000m" "1Gi";
        infraMini = mkProfile "10m" "32Mi" "100m" "64Mi";
        infraSmall = mkProfile "20m" "48Mi" "150m" "128Mi";
        infraMedium = mkProfile "50m" "64Mi" "200m" "192Mi";
        infraLarge = mkProfile "100m" "128Mi" "250m" "256Mi";
      };
    in
    {
      options.server.resources.profiles = lib.mkOption {
        type = lib.types.attrs;
        default = resourceProfiles;
        description = "Kubernetes resource profiles";
      };
    };
}
