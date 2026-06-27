{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.cert-manager-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      controllerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-controller";
        imageDigest = "sha256:6c13d61e0348a5bc3477f8ea9a928624300b30d19b1c72a7d2b90372fc713db4";
        hash = "sha256-FuaUNHWiEGVY/JJJrt0fdyqE2kc4WPGJqTvkrQsp36Q=";
        finalImageTag = "v1.20.3";
        arch = "amd64";
      };
      webhookImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-webhook";
        imageDigest = "sha256:a61e817632cebed3bb59a189327e786fa3fdd7597167d994a1848d98fd55848f";
        hash = "sha256-hy24N+ppukUqYa+qa8TbDSkb//ZXqu9H2fZEcrZ+kM8=";
        finalImageTag = "v1.20.3";
        arch = "amd64";
      };
      cainjectorImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-cainjector";
        imageDigest = "sha256:06ad347fe0dc2eb84cc355c26f6752e05e87dceb6447f5cd29b963dd66dfd8bd";
        hash = "sha256-Ajw51VLzZoSetVWIgZrOq8j+PbmzKPg2ppDtrPy5R/M=";
        finalImageTag = "v1.20.3";
        arch = "amd64";
      };
      startupapicheckImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-startupapicheck";
        imageDigest = "sha256:b0c9a2c18d02f3c40a9e091a6fe9afdf39cbf7fb2d9acc18c9881c21c625f2dc";
        hash = "sha256-VbleV7fCeKVrgFp+EucPjuZmio7ANytHH+nF9tKP3vk=";
        finalImageTag = "v1.20.3";
        arch = "amd64";
      };
      acmesolverImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-acmesolver";
        imageDigest = "sha256:d8d948a9fa0fb9eeb9fd2432dee4945cc202c840ee25a733f0b238fd89fe5cbb";
        hash = "sha256-XoFkKdFvbNaH7GKGA3MbnwjN6UrbwTf0OV900tPl2Wg=";
        finalImageTag = "v1.20.3";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.cert-manager.enable {
        services.k3s.images = [
          controllerImage
          webhookImage
          cainjectorImage
          startupapicheckImage
          acmesolverImage
        ];
      };
    };
}
