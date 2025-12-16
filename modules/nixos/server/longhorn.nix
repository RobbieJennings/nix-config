{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  chart = {
    name = "longhorn";
    repo = "https://charts.longhorn.io";
    version = "1.10.0";
    hash = "sha256-K+nao6QNuX6R/WoyrtCly9kXvUHwsA3h5o8KmOajqAs=";
  };
  csiAttacherImage = pkgs.dockerTools.pullImage {
    imageName = "longhornio/csi-attacher";
    imageDigest = "sha256:af29125d83075b95894e95862dde03908b1970858f1d6399917305b92d2713a6";
    sha256 = "sha256-fSEQ6iUnr7qDdPI59lZIb3mExbRM+6nTV9HY9dXOYp8=";
    finalImageTag = "v4.10.0-20251030";
    arch = "amd64";
  };
  csiNodeDriverRegistrarImage = pkgs.dockerTools.pullImage {
    imageName = "longhornio/csi-node-driver-registrar";
    imageDigest = "sha256:cc125aa681e8ff41ef97bf72b8c16cafffa84f8493ecbcf606e5463f90e9cbd3";
    sha256 = "sha256-FcgRdmuQc/E4tOwJfIy98KS682EC1QnXAVIHiFDz0a0=";
    finalImageTag = "v2.15.0-20251030";
    arch = "amd64";
  };
  csiProvisionerImage = pkgs.dockerTools.pullImage {
    imageName = "longhornio/csi-provisioner";
    imageDigest = "sha256:fe31c68584e80a2af9ae14e0682b3cea076218a0756ae7add0a421c21486a4d0";
    sha256 = "sha256-vZ1ifQSUC0uswdGjueNU4HciIULTWvriNaO6gfeoDJ4=";
    finalImageTag = "v5.3.0-20251030";
    arch = "amd64";
  };
  csiResizerImage = pkgs.dockerTools.pullImage {
    imageName = "longhornio/csi-resizer";
    imageDigest = "sha256:748b61cb91ba4cc4bc35ba38bdac73c130602262458f388b0116eb96a4690e94";
    sha256 = "sha256-SxgDbSseKIRfN3tZufyvMXSxHy9EJf6x6jmZttieLsc=";
    finalImageTag = "v1.14.0-20251030";
    arch = "amd64";
  };
  csiSnapshotterImage = pkgs.dockerTools.pullImage {
    imageName = "longhornio/csi-snapshotter";
    imageDigest = "sha256:2cc2f9e653c2b397e8eefffbfb4ccf8eabc5f7d84e1f875d42608484a66c307f";
    sha256 = "sha256-N7zYMfgAaOC6f0g/s5+WyL/UrZKRc3LBXLC2DP1lxdQ=";
    finalImageTag = "v8.4.0-20251030";
    arch = "amd64";
  };
  longhornEngineImage = pkgs.dockerTools.pullImage {
    imageName = "longhornio/longhorn-engine";
    imageDigest = "sha256:5b265b8dcbbb4a21459a8f2e8e42292d87ad0ee4dda5ab9b32ca7b35a64f8240";
    sha256 = "sha256-vd70ZLpAfAQSf353SmsXKg5/YHqHOnQwpcC/PzIU4YY=";
    finalImageTag = "v1.10.1-rc2";
    arch = "amd64";
  };
  longhornInstanceManagerImage = pkgs.dockerTools.pullImage {
    imageName = "longhornio/longhorn-instance-manager";
    imageDigest = "sha256:2f78d6651a3afea919431a69c3bad9c250b0f336805af50119893da8f39a6c0d";
    sha256 = "sha256-xzO/MY8QkKNbGyIeujGN4hS2hTpgOtdPIVCeKxww/AU=";
    finalImageTag = "v1.10.1-rc2";
    arch = "amd64";
  };
  longhornManagerImage = pkgs.dockerTools.pullImage {
    imageName = "longhornio/longhorn-manager";
    imageDigest = "sha256:f5fde96a232654c9139732d6f60af9651b2b4abbc913684e7c0f724b153401e4";
    sha256 = "sha256-aoH959uavb4hhVjCF+YmajYPr72/T5wHThnncf/o264=";
    finalImageTag = "v1.10.1-rc2";
    arch = "amd64";
  };
  longhornShareManagerImage = pkgs.dockerTools.pullImage {
    imageName = "longhornio/longhorn-share-manager";
    imageDigest = "sha256:c865d3021e49824a1fb65b849e3d1c462d94890118622364d63a0fc2cb9d915e";
    sha256 = "sha256-duLHC0+02+YyOayYM7Xl8UmImE9YZaTT4cZKrBmZQZY=";
    finalImageTag = "v1.10.1-rc2";
    arch = "amd64";
  };
  longhornUiImage = pkgs.dockerTools.pullImage {
    imageName = "longhornio/longhorn-ui";
    imageDigest = "sha256:dbaf9535e439001800798f90ed73ed1a32fd268825918f7ad3d388e412b981f9";
    sha256 = "sha256-3dfDMIM8cHwmyvtHxc2SlyBMaur28yacR5biiS7zDDA=";
    finalImageTag = "v1.10.1-rc2";
    arch = "amd64";
  };
in
{
  options = {
    server.longhorn.enable = lib.mkEnableOption "longhorn helm chart on k3s";
  };

  config = lib.mkIf config.server.longhorn.enable {
    systemd.tmpfiles.rules = [
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    ];
    environment.systemPackages = [
      pkgs.util-linux
      pkgs.nfs-utils
    ];
    services.openiscsi = {
      enable = true;
      name = "${config.networking.hostName}-initiatorhost";
    };
    services.k3s = {
      images = [
        csiAttacherImage
        csiNodeDriverRegistrarImage
        csiProvisionerImage
        csiResizerImage
        csiSnapshotterImage
        longhornEngineImage
        longhornInstanceManagerImage
        longhornManagerImage
        longhornShareManagerImage
        longhornUiImage
      ];
      autoDeployCharts.longhorn = chart // {
        targetNamespace = "longhorn-system";
        createNamespace = true;
        values = {
          defaultSettings.defaultReplicaCount = "1";
          longhornUI.replicas = 1;
          persistence = {
            defaultClassReplicaCount = 1;
            reclaimPolicy = "Retain";
          };
          csi = {
            attacherReplicaCount = "1";
            provisionerReplicaCount = "1";
            resizerReplicaCount = "1";
            snapshotterReplicaCount = "1";
          };
          image = {
            csi = {
              attacher = {
                repository = csiAttacherImage.imageName;
                tag = csiAttacherImage.imageTag;
              };
              nodeDriverRegirar = {
                repository = csiNodeDriverRegistrarImage.imageName;
                tag = csiNodeDriverRegistrarImage.imageTag;
              };
              provisioner = {
                repository = csiProvisionerImage.imageName;
                tag = csiProvisionerImage.imageTag;
              };
              resizer = {
                repository = csiResizerImage.imageName;
                tag = csiResizerImage.imageTag;
              };
              snapshotter = {
                repository = csiSnapshotterImage.imageName;
                tag = csiSnapshotterImage.imageTag;
              };
            };
            longhorn = {
              engine = {
                repository = longhornEngineImage.imageName;
                tag = longhornEngineImage.imageTag;
              };
              instanceManager = {
                repository = longhornInstanceManagerImage.imageName;
                tag = longhornInstanceManagerImage.imageTag;
              };
              manager = {
                repository = longhornManagerImage.imageName;
                tag = longhornManagerImage.imageTag;
              };
              shareManager = {
                repository = longhornShareManagerImage.imageName;
                tag = longhornShareManagerImage.imageTag;
              };
              ui = {
                repository = longhornUiImage.imageName;
                tag = longhornUiImage.imageTag;
              };
            };
          };
          service.ui = {
            type = "LoadBalancer";
            loadBalancerIP = "192.168.0.201";
            annotations = {
              "metallb.io/address-pool" = "default";
            };
          };
        };
      };
    };
  };
}
