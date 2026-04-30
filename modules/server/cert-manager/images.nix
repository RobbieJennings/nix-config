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
        imageDigest = "sha256:9cad8065bbf57815cbcfa813b903dd8822bcd0271f7443192082b54e96a55585";
        sha256 = "sha256-Y62uJTWMBJam9SNgbA/3DK30SreMs4Ad69qDGTeVL/U=";
        finalImageTag = "v1.19.4";
        arch = "amd64";
      };
      webhookImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-webhook";
        imageDigest = "sha256:f41b4ac798c8ff200c29756cf86e70a00e73fe489fb6ab80d9210d1b5f476852";
        sha256 = "sha256-o/D7ReLs3gAfdTbTb5Fdz7/vJ31ca0+tawnMsylpHvM=";
        finalImageTag = "v1.19.4";
        arch = "amd64";
      };
      cainjectorImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-cainjector";
        imageDigest = "sha256:5d810724b177746a8aeafd5db111b55b72389861bcec03a6d50f9c6d56ec37c0";
        sha256 = "sha256-T1N61mUjeAZ1e8JXQQjSnJ+vncYb++TcHHwDF7/S6es=";
        finalImageTag = "v1.19.4";
        arch = "amd64";
      };
      startupapicheckImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-startupapicheck";
        imageDigest = "sha256:8e897895b9e9749447ccb84842176212195f4687e0a3c4ca892d9d410e0fd43e";
        sha256 = "sha256-MH60aRDXMGI33VmKDwEVFqHUBdPcGOyfvA8ISP0y32g=";
        finalImageTag = "v1.19.4";
        arch = "amd64";
      };
      acmesolverImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/jetstack/cert-manager-acmesolver";
        imageDigest = "sha256:7688c3e2d7e5338deb630da911fff3752c72a7bf70f94608c223f96af40c8399";
        sha256 = "sha256-A8q3DWdn25bAXkHTgyWmcXrQhsjbVMhcA4FPrrhpreY=";
        finalImageTag = "v1.19.4";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.cert-manager.enable {
        services.k3s = {
          images = [
            controllerImage
            webhookImage
            cainjectorImage
            startupapicheckImage
            acmesolverImage
          ];
          autoDeployCharts.cert-manager.values = {
            image = {
              repository = controllerImage.imageName;
              tag = controllerImage.imageTag;
            };
            startupapicheck.image = {
              repository = startupapicheckImage.imageName;
              tag = startupapicheckImage.imageTag;
            };
            acmesolver.image = {
              repository = acmesolverImage.imageName;
              tag = acmesolverImage.imageTag;
            };
          };
        };
      };
    };
}
