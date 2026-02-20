{
  inputs,
  ...
}:
{
  flake.modules.nixos.longhorn =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "longhorn";
        repo = "https://charts.longhorn.io";
        version = "1.10.1";
        hash = "sha256-qHHTl+Gc8yQ5SavUH9KUhp9cLEkAFPKecYZqJDPsf7k=";
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
        imageDigest = "sha256:b6b30ace865932a686afde56757213d6c86834645443f3af1528a93b7ddf52f4";
        sha256 = "sha256-ussctYityuRM7DmqtKKGorj22SkcVHvtc3OP03A3xF8=";
        finalImageTag = "v1.10.1";
        arch = "amd64";
      };
      longhornInstanceManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-instance-manager";
        imageDigest = "sha256:84e0a5c1d67599a445f5b4fa853152ff53f6b1bd42a7cf7c01f4152cf60782af";
        sha256 = "sha256-+6DObQfiNghYFuMfERjjToOOkN1ZOGGTt4DWBF9c4GU=";
        finalImageTag = "v1.10.1";
        arch = "amd64";
      };
      longhornManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-manager";
        imageDigest = "sha256:afda26c16e7ab106f94dbc11da1bc91f410487d2e66609ebd126f0d908f7243a";
        sha256 = "sha256-BP01Yxeaqq256XNXgctc2NWSdONVNkmJlS+e6izTCIU=";
        finalImageTag = "v1.10.1";
        arch = "amd64";
      };
      longhornShareManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-share-manager";
        imageDigest = "sha256:1edc95ae8f9e9699f9b082bf0eac82b338b2f120462424201957cb6287b2e3e9";
        sha256 = "sha256-3CJxq42YuXusgcWdLuzgTrsAgivlRM5M+5WsxpHrTDU=";
        finalImageTag = "v1.10.1";
        arch = "amd64";
      };
      longhornUiImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-ui";
        imageDigest = "sha256:62fd171f4fbed01ebb51653674c68ea1c531aa562dab23cb029033dffd6bccc6";
        sha256 = "sha256-Fx64zHqaeQq9kM9fYEJAOVCIx0EtfHy/qj56cd4S2BQ=";
        finalImageTag = "v1.10.1";
        arch = "amd64";
      };
    in
    {
      options = {
        longhorn.enable = lib.mkEnableOption "longhorn helm chart on k3s";
      };

      config = lib.mkIf config.longhorn.enable {
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
              defaultSettings = {
                defaultReplicaCount = 1;
              };
              persistence = {
                defaultClassReplicaCount = 1;
                reclaimPolicy = "Retain";
              };
              csi = {
                attacherReplicaCount = 1;
                provisionerReplicaCount = 1;
                resizerReplicaCount = 1;
                snapshotterReplicaCount = 1;
              };
              image = {
                csi = {
                  attacher = {
                    repository = csiAttacherImage.imageName;
                    tag = csiAttacherImage.imageTag;
                  };
                  nodeDriverRegistrar = {
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
    };
}
