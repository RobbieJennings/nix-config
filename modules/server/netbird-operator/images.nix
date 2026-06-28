{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.netbird-operator-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      operatorImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/netbirdio/netbird-operator";
        imageDigest = "sha256:4ac288a3c2534553dc5cef02b6fd258673cf82822c5d90a06f16eaaffbe70bf8";
        hash = "sha256-KkQM0EbNzX2hCjiZ/EGcXMdS9ZutkiEYy689yhPoS9g=";
        finalImageTag = "v0.7.0";
        arch = "amd64";
      };
      routerImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/netbirdio/netbird";
        imageDigest = "sha256:b41e7f4197e4e7fde09effc6722e182cc96b39625114e0830227d407670db607";
        hash = "sha256-KFm29OcXByByzkZ9kbDmtLq++IbxpI1e9LUNjz6bhNI=";
        finalImageTag = "0.71.4-rootless";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.netbird-operator.enable {
        services.k3s.images = [
          operatorImage
          routerImage
        ];
      };
    };
}
