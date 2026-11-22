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
          image = {
            csi = {
              attacher = {
                repository = config._module.args.longhornImages.csiAttacherImage.imageName;
                tag = config._module.args.longhornImages.csiAttacherImage.imageTag;
              };
              nodeDriverRegistrar = {
                repository = config._module.args.longhornImages.csiNodeDriverRegistrarImage.imageName;
                tag = config._module.args.longhornImages.csiNodeDriverRegistrarImage.imageTag;
              };
              provisioner = {
                repository = config._module.args.longhornImages.csiProvisionerImage.imageName;
                tag = config._module.args.longhornImages.csiProvisionerImage.imageTag;
              };
              resizer = {
                repository = config._module.args.longhornImages.csiResizerImage.imageName;
                tag = config._module.args.longhornImages.csiResizerImage.imageTag;
              };
              snapshotter = {
                repository = config._module.args.longhornImages.csiSnapshotterImage.imageName;
                tag = config._module.args.longhornImages.csiSnapshotterImage.imageTag;
              };
              livenessProbe = {
                repository = config._module.args.longhornImages.csiLivenessProbeImage.imageName;
                tag = config._module.args.longhornImages.csiLivenessProbeImage.imageTag;
              };
            };
            longhorn = {
              engine = {
                repository = config._module.args.longhornImages.longhornEngineImage.imageName;
                tag = config._module.args.longhornImages.longhornEngineImage.imageTag;
              };
              instanceManager = {
                repository = config._module.args.longhornImages.longhornInstanceManagerImage.imageName;
                tag = config._module.args.longhornImages.longhornInstanceManagerImage.imageTag;
              };
              manager = {
                repository = config._module.args.longhornImages.longhornManagerImage.imageName;
                tag = config._module.args.longhornImages.longhornManagerImage.imageTag;
              };
              shareManager = {
                repository = config._module.args.longhornImages.longhornShareManagerImage.imageName;
                tag = config._module.args.longhornImages.longhornShareManagerImage.imageTag;
              };
              ui = {
                repository = config._module.args.longhornImages.longhornUiImage.imageName;
                tag = config._module.args.longhornImages.longhornUiImage.imageTag;
              };
            };
          };
          longhornUI.replicas = 1;
          longhornGlobalManager.replicas = 1;
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
          defaultBackupStore = {
            backupTarget = "s3://longhorn-bucket@garage/";
            backupTargetCredentialSecret = "longhorn-backup-secret";
          };
          metrics.serviceMonitor = {
            enabled = true;
            additionalLabels.release = "prometheus";
          };
          networkPolicies.metricsScrapeSources = [
            {
              namespaceSelector.matchLabels."kubernetes.io/metadata.name" = "monitoring";
              podSelector.matchLabels."app.kubernetes.io/name" = "prometheus";
            }
          ];
        };
      };
    };
}
