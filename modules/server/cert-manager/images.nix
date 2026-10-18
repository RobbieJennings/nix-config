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
        imageDigest = "sha256:70f532fd9cfde0b09d55687200942399d89838bc2d5d5b45152eb799a15912b8";
        hash = "sha256-PQrjeF5Oy+T44S9+BHCwdbSwXU4+EsrCu8AdCuWKWdE=";
        finalImageTag = "v1.21.2";
        arch = "amd64";
      };
      webhookImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-webhook";
        imageDigest = "sha256:a60e2dac46dbb8a7f3df95c54ce941012f54c2fe022f0ee55aaa1ab40ed957ae";
        hash = "sha256-gbv5LNTgIzRZgLnaNzIdLYEexlEcJfP+rb2zzscHNEA=";
        finalImageTag = "v1.21.2";
        arch = "amd64";
      };
      cainjectorImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-cainjector";
        imageDigest = "sha256:c85268c64f2e0e76684bf5fe8906caff34b82523561c6affe0fae3546bd87562";
        hash = "sha256-b3O8trqxnwVPOTiKOJuBUSZIIcXn0Lzc2XINHLB+NU4=";
        finalImageTag = "v1.21.2";
        arch = "amd64";
      };
      startupapicheckImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-startupapicheck";
        imageDigest = "sha256:46e75b6866359ffb5d82624f41e3ed1c70b2994982702ced547ce5edb418a8f5";
        hash = "sha256-+qOCZi9lm9Z7WzAOAUD32Wrs/Xdtq2EQHL+/u+2LPws=";
        finalImageTag = "v1.21.2";
        arch = "amd64";
      };
      acmesolverImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-acmesolver";
        imageDigest = "sha256:699b40d622211ab7accad8a21b04c5fbaa1841ef7a12621e8de492dbe27b2503";
        hash = "sha256-Ez7JMiK895M/sKBMubDCCLwVHlIz+D6pNSXms2r87qY=";
        finalImageTag = "v1.21.2";
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
