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
              attacher =
                let
                  image = inputs.self.lib.findImageByName "longhornio/csi-attacher" config.services.k3s.images;
                in
                {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
              nodeDriverRegistrar =
                let
                  image = inputs.self.lib.findImageByName "longhornio/csi-node-driver-registrar" config.services.k3s.images;
                in
                {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
              provisioner =
                let
                  image = inputs.self.lib.findImageByName "longhornio/csi-provisioner" config.services.k3s.images;
                in
                {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
              resizer =
                let
                  image = inputs.self.lib.findImageByName "longhornio/csi-resizer" config.services.k3s.images;
                in
                {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
              snapshotter =
                let
                  image = inputs.self.lib.findImageByName "longhornio/csi-snapshotter" config.services.k3s.images;
                in
                {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
              livenessProbe =
                let
                  image = inputs.self.lib.findImageByName "longhornio/livenessprobe" config.services.k3s.images;
                in
                {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
            };
            longhorn = {
              engine =
                let
                  image = inputs.self.lib.findImageByName "longhornio/longhorn-engine" config.services.k3s.images;
                in
                {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
              instanceManager =
                let
                  image = inputs.self.lib.findImageByName "longhornio/longhorn-instance-manager" config.services.k3s.images;
                in
                {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
              manager =
                let
                  image = inputs.self.lib.findImageByName "longhornio/longhorn-manager" config.services.k3s.images;
                in
                {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
              shareManager =
                let
                  image = inputs.self.lib.findImageByName "longhornio/longhorn-share-manager" config.services.k3s.images;
                in
                {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
              ui =
                let
                  image = inputs.self.lib.findImageByName "longhornio/longhorn-ui" config.services.k3s.images;
                in
                {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
            };
          };
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
          defaultBackupStore = {
            backupTarget = "s3://longhorn-bucket@garage/";
            backupTargetCredentialSecret = "longhorn-backup-secret";
          };
        };
      };
    };
}
