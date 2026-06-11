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
        imageDigest = "sha256:fe417c28a6b86f8e7e5d49fc223e22e9ab457f894d2c4a321932d136dc2c2530";
        hash = "sha256-+defbWikOWKmZvwOX8vAy5cbwQa6EDiJOnfOLe4fzuo=";
        finalImageTag = "v4.11.0-20260428";
        arch = "amd64";
      };
      csiNodeDriverRegistrarImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-node-driver-registrar";
        imageDigest = "sha256:e82a8c8f800d7fbb3c1edf3f90b557768091821a44d52280093394f7918ccb68";
        hash = "sha256-tcltO1AEnHotTxyJ+N7FbzvBS2U1DgOrikGBB8lOA2k=";
        finalImageTag = "v2.16.0-20260428";
        arch = "amd64";
      };
      csiProvisionerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-provisioner";
        imageDigest = "sha256:9e519a21a77c060104716e1f98222bb46ab617778a3bfcd861c87119a8256764";
        hash = "sha256-nUkForHWNHisq1cMNTjzJ3wuy7dmWBHSi/H2Zaa6ewA=";
        finalImageTag = "v5.3.0-20260428";
        arch = "amd64";
      };
      csiResizerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-resizer";
        imageDigest = "sha256:41cb674d1154e798aa2c20f53f72ee2a5597f1369bcad5878d1708aee47f6663";
        hash = "sha256-BPXAG3NIacqmf3f8V4kjWZIfYw3Becdn8oCuNStGulE=";
        finalImageTag = "v2.1.0-20260428";
        arch = "amd64";
      };
      csiSnapshotterImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/csi-snapshotter";
        imageDigest = "sha256:1975fac3890f4e08b98792881cb597502112ce0eeeaaef383e52458c96db94c5";
        hash = "sha256-tDLxZZUsFzerg1q0ofOD5IrdtxH2ywFFjJ3u/rG79xc=";
        finalImageTag = "v8.5.0-20260428";
        arch = "amd64";
      };
      csiLivenessProbeImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/livenessprobe";
        imageDigest = "sha256:eae162f7e70fb981f90d9206f299dddaf590c0c896cfb67acceca12cef526a44";
        hash = "sha256-qZqaIl3LqLd0og1DEM5KwKh5P0lMlRZyUDIhyrFJ8L8=";
        finalImageTag = "v2.18.0-20260428";
        arch = "amd64";
      };
      longhornEngineImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-engine";
        imageDigest = "sha256:7482e0437fbf475e1e32696fab22f47bf99b1ef8d067ffce9e34028347722628";
        hash = "sha256-3ceS6YUy/h0W1Ofi0ZT9lafGf3MRWr6JZ1H/MqgM8t0=";
        finalImageTag = "v1.11.2";
        arch = "amd64";
      };
      longhornInstanceManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-instance-manager";
        imageDigest = "sha256:16dac125ef30bd3a375bc8ff7d10636ea0302d22d208c0cfb1be37ebb93ca30b";
        hash = "sha256-gElWLr5Mk6ZPkUgsIDNHvuS53WXTC9Rn2YMUKdmQydI=";
        finalImageTag = "v1.11.2";
        arch = "amd64";
      };
      longhornManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-manager";
        imageDigest = "sha256:0f80ca11ac4eb7522f4e6e801a7afc9909ea8d3041575f3d029964c46590f096";
        hash = "sha256-w2BvuR0oPN9H1fY3DYGd+5+pj0ECOmoEfuAMOnW7vjo=";
        finalImageTag = "v1.11.2";
        arch = "amd64";
      };
      longhornShareManagerImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-share-manager";
        imageDigest = "sha256:c11559e998ea982e6bac1637d66cc2aaab662a6b546709f2e54e2bfa50ffb0c3";
        hash = "sha256-1JByktvTg0MWqF4qGn74zmfX/az/GjMux0RrYxMRIE8=";
        finalImageTag = "v1.11.2";
        arch = "amd64";
      };
      longhornUiImage = pkgs.dockerTools.pullImage {
        imageName = "longhornio/longhorn-ui";
        imageDigest = "sha256:885bc78f99f31da0d9b0fd8f533a53558a3aa81f9719c62e0d3c69ed8456d5b7";
        hash = "sha256-z8/YJtkoVM2CKnoO1yoJdl+OfKQWuiw8VNbipj2ZOUs=";
        finalImageTag = "v1.11.2";
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
