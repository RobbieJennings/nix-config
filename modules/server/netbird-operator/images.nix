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
        imageDigest = "sha256:4f1893ea708f7f0cdafc6f77f400415e2a81350db57f0fa74dda3c2d6bd02772";
        hash = "sha256-wvOZ8AY3cjnCbkm0aqz+p1/VBTgFCUrM5yT0CicztV4=";
        finalImageTag = "0.73.2-rootless";
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
