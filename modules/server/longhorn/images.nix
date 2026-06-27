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
        imageDigest = "sha256:a814aa4784197116983ea13e376fc691e000a390de9d0b9fca2bc4a2fb7c4a1f";
        hash = "sha256-K1VTAWKsNGqtMVCU20zDDigK2o/WiL28g7EZNuuseLs=";
        finalImageTag = "v4.12.0";
        arch = "amd64";
      };
      csiNodeDriverRegistrarImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-node-driver-registrar";
        imageDigest = "sha256:29f7cfd519008fe8f8dff5e79db43f70d65c43a89c08f1bafbb199ca90df79f0";
        hash = "sha256-4S6BYwTT12b4/338g1U0+aOBsZmFgC1nreKMdM3O1xo=";
        finalImageTag = "v2.17.0";
        arch = "amd64";
      };
      csiProvisionerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-provisioner";
        imageDigest = "sha256:05c4017e4df7f8f690d6578f975f1eba94624d1b6a675d88c5f508ab6a27152b";
        hash = "sha256-QnGu5lGQRG1wNGAYohj3CGql7yFQZ49PAMo1XdLkGbQ=";
        finalImageTag = "v5.3.0-20260514";
        arch = "amd64";
      };
      csiResizerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-resizer";
        imageDigest = "sha256:7f203c1f195445e8ca8be258cd6179c284885a6c1b5287e6c0e33870e9083f8a";
        hash = "sha256-Xq3CEeNg1uQeB2sBRR4TOBgeJ16TAn12Q6K7WtolVgU=";
        finalImageTag = "v2.1.0-20260514";
        arch = "amd64";
      };
      csiSnapshotterImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-snapshotter";
        imageDigest = "sha256:df4ba2075c00c5193821d43caf11c6f6556310247723365e9916e409799ce029";
        hash = "sha256-B6ScMLk19zU/s+oV47X+/l6mjrfa+b7uYIf381Ey/ds=";
        finalImageTag = "v8.5.0-20260514";
        arch = "amd64";
      };
      csiLivenessProbeImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/livenessprobe";
        imageDigest = "sha256:d0cb76b565ba9d36da0dc2b38e2b6a49a0ae4fe067b03086110682f32c600318";
        hash = "sha256-IdCAKXzZy2QIU+I9gZf8FnIc2ZEJI3QtY6gOTp8AbWs=";
        finalImageTag = "v2.19.0";
        arch = "amd64";
      };
      longhornEngineImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-engine";
        imageDigest = "sha256:bc4a49e8f2b6b4bcdde0f6e465c0b0ac94acf6198840f9db039bedbbae67e905";
        hash = "sha256-PSbSVKgi2CRRQF2gNOCCiwVATFri/S6FJ9AjKXms3II=";
        finalImageTag = "v1.12.0";
        arch = "amd64";
      };
      longhornInstanceManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-instance-manager";
        imageDigest = "sha256:7dc270841c8a8855b9c7b192b53db05b6268318648108cea4b00c2e88eb85cbb";
        hash = "sha256-WEg1rMTuHyS4zkRQMTmDHlRNi+ROioKdGyvpxwTme8s=";
        finalImageTag = "v1.12.0";
        arch = "amd64";
      };
      longhornManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-manager";
        imageDigest = "sha256:fd245bae2e8254ed475073410f8462e95fab8783dd12d1c084777b5ab53bfb86";
        hash = "sha256-1n9TdQT24haKUm8BRBQLmk9koL2BJATwcjOSAXl+wvM=";
        finalImageTag = "v1.12.0";
        arch = "amd64";
      };
      longhornShareManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-share-manager";
        imageDigest = "sha256:cb9d6863e4c694d82ab35f91184d9555c536ed292dad0c7dec94cb655e05787e";
        hash = "sha256-v6rlqXIBo0/Fp0pCf75SVWrTTyW0/Th1woKF9Kw0dio=";
        finalImageTag = "v1.12.0";
        arch = "amd64";
      };
      longhornUiImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-ui";
        imageDigest = "sha256:3870d52a2b0aa44e7f8a30d744cfe38a1a0bd130226d3f5d08795e76361ff0b7";
        hash = "sha256-DfM+WZNjmfBoHrrQF7WFRQmDWZxCtIKEO514P0SIZis=";
        finalImageTag = "v1.12.0";
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
