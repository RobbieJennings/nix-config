{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.longhorn-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.longhorn.enable {
        services.k3s.autoDeployCharts.longhorn.values = {
          longhornUI.replicas = 1;
          defaultSettings = {
            defaultReplicaCount = 1;
            storageMinimalAvailablePercentage = 10;
            storageReservedPercentageForDefaultDisk = 10;
          };
          csi = {
            attacherReplicaCount = 1;
            provisionerReplicaCount = 1;
            resizerReplicaCount = 1;
            snapshotterReplicaCount = 1;
          };
          persistence = {
            defaultClassReplicaCount = 1;
            reclaimPolicy = "Retain";
          };
        };
      };
    };
}
