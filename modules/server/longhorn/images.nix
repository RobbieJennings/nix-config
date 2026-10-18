{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.longhorn-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      csiAttacherImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-attacher";
        imageDigest = "sha256:fef34c2d823b78da7d6c29fdf0f80d236293b0ac06944d14e8c366add880a4c8";
        hash = "sha256-7fNB7q9Er6Kt+h9CpKkWc5q2vTFh7P/20RvFwJFVJwg=";
        finalImageTag = "v4.13.0";
        arch = "amd64";
      };
      csiNodeDriverRegistrarImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-node-driver-registrar";
        imageDigest = "sha256:085f63e62fea391734f5668d9cbb20ac8788a8e7faea83ce2c994f0cc1834fce";
        hash = "sha256-G3o/PNGbulTUJRV6Y5JN8PrZhZjlQAAArkmqKwtSs9M=";
        finalImageTag = "v2.18.0";
        arch = "amd64";
      };
      csiProvisionerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-provisioner";
        imageDigest = "sha256:2d2694540109d2e8887f62a0bc711aca8d3033e52dddf1c39bb5c65600d9c5af";
        hash = "sha256-cCLgyH9NklND+2eo1YbLnumPhfh7BEEkpmwkvs9ZnJM=";
        finalImageTag = "v6.3.0";
        arch = "amd64";
      };
      csiResizerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-resizer";
        imageDigest = "sha256:63d0aef25114d4a682b25afa6d9623a3cfcc19aca910269124408476bbe2c6fd";
        hash = "sha256-jpdQ4qN6cuWMN8chSGDbQ0GRiswmMmlF4e5TX+wTdfE=";
        finalImageTag = "v2.2.1";
        arch = "amd64";
      };
      csiSnapshotterImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-snapshotter";
        imageDigest = "sha256:2bca9ac55170efa61dc50e5cc8d9550373db2e3e5161d82d3fdaac5c25150360";
        hash = "sha256-vhpFElDccyMVGB4XtiZ04iT8mbaW88FzEn/Ccc+ZlhE=";
        finalImageTag = "v8.6.0";
        arch = "amd64";
      };
      csiLivenessProbeImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/livenessprobe";
        imageDigest = "sha256:d1199b77452bfc11cfc62feb8a266758fe8d72953e97faac8065941e3767f1a3";
        hash = "sha256-IDAapl0yUAZq9UmftCFrkX7tjYEB+S7Nzteil6B18pE=";
        finalImageTag = "v2.20.0";
        arch = "amd64";
      };
      longhornEngineImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-engine";
        imageDigest = "sha256:b0cc5090889d57705acd69c5106492992e84560170ac3bec4a1cc8dd3fe83ca6";
        hash = "sha256-4NSQfj+z5CFxxAyisw0kKyoWZgPACYOq4/CgJ2XQrdY=";
        finalImageTag = "v1.13.0";
        arch = "amd64";
      };
      longhornInstanceManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-instance-manager";
        imageDigest = "sha256:fc9e1c15e81988b04c146866ce7010b6df3a70f88302809bf53e19b27d1658a3";
        hash = "sha256-m/d98c6o9pJf3kwO4g0MwDv4rrQrss46qdFvCCl2NoE=";
        finalImageTag = "v1.13.0";
        arch = "amd64";
      };
      longhornManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-manager";
        imageDigest = "sha256:7372f3c59239e9a67c0017b3af32fabdf08c4dcc0631140161da9a47e3b142f0";
        hash = "sha256-y+kQF/ZD/OhxH/ykmwenzGkKVYCl7eg0I+JUkzILFXE=";
        finalImageTag = "v1.13.0";
        arch = "amd64";
      };
      longhornShareManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-share-manager";
        imageDigest = "sha256:53950f78b7af38b8a943c298cd3020622191a4661a13036f69d83c154cc8690d";
        hash = "sha256-N4NLHZbP6CRJiaIu/7OuuTxoiGBbzkLgmGDbXJ5vXKA=";
        finalImageTag = "v1.13.0";
        arch = "amd64";
      };
      longhornUiImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-ui";
        imageDigest = "sha256:f22fb0254ae50195c1635ce428dfae26375956b3d7bd39640fae8fe33a236023";
        hash = "sha256-PjI+Xeos9J4Js2XnAU1XaapdIcwLiOZtFxZFkPuHbZc=";
        finalImageTag = "v1.13.0";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.longhorn.enable {
        services.k3s.images = [
          csiAttacherImage
          csiNodeDriverRegistrarImage
          csiProvisionerImage
          csiResizerImage
          csiSnapshotterImage
          csiLivenessProbeImage
          longhornEngineImage
          longhornInstanceManagerImage
          longhornManagerImage
          longhornShareManagerImage
          longhornUiImage
        ];
      };
    };
}
