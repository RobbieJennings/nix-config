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
        imageDigest = "sha256:fe0623d7d04a382c888f03343a3a2da716e0d96ad3d5d790c0ebcbcb2a4329a5";
        hash = "sha256-lcjoakYzDhQiCb5Bu5ZLFf8exWYqhzFRjHEi3jpZpaA=";
        finalImageTag = "v1.20.2";
        arch = "amd64";
      };
      webhookImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-webhook";
        imageDigest = "sha256:baf651128b9f05c426cbd5e60e2036bf382c99ca270f49d0757d6f7d2452f4e5";
        hash = "sha256-Tq+dBEIAV1ButQCgZ7fKfRie8B2VwnDC4GUVTDc1CQA=";
        finalImageTag = "v1.20.2";
        arch = "amd64";
      };
      cainjectorImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-cainjector";
        imageDigest = "sha256:6f5a644135887b2aa7d5cc145072fa56421560e3586ff1f184358022d490f4e1";
        hash = "sha256-k7KNy3kmJS9qQft0sNYC3UnhVPA9CS/nDDbNDdp4emg=";
        finalImageTag = "v1.20.2";
        arch = "amd64";
      };
      startupapicheckImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-startupapicheck";
        imageDigest = "sha256:4e2a69b4a0cc9627905bbeecf720f95d5153ca39cacdab923d2748e73556792b";
        hash = "sha256-qqs3zPuv+8PkcgMAUATH15/r7Wppq+OyhAgvseeKIhM=";
        finalImageTag = "v1.20.2";
        arch = "amd64";
      };
      acmesolverImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-acmesolver";
        imageDigest = "sha256:cfa55e9c3dcfc6a3cba97575748c1549b04a30fd14d88a2fcb9e2dddef415e2f";
        hash = "sha256-Z5l7BLZechvTl3S4dOVRCFoO7q0YrXyXtlbiwKhzJZE=";
        finalImageTag = "v1.20.2";
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
