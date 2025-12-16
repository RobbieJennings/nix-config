{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  chart = {
    name = "hello-world";
    repo = "https://helm.github.io/examples";
    version = "0.1.0";
    hash = "sha256-U2XjNEWE82/Q3KbBvZLckXbtjsXugUbK6KdqT5kCccM=";
  };
  image = pkgs.dockerTools.pullImage {
    imageName = "nginx";
    imageDigest = "sha256:4ff102c5d78d254a6f0da062b3cf39eaf07f01eec0927fd21e219d0af8bc0591";
    sha256 = "sha256-Fh9hWQWgY4g+Cu/0iER4cXAMvCc0JNiDwGCPa+V/FvA=";
    finalImageTag = "1.27.4-alpine";
    arch = "amd64";
  };
in
{
  options = {
    server.hello-world.enable = lib.mkEnableOption "hello world helm chart on k3s";
  };

  config = lib.mkIf config.server.hello-world.enable {
    services.k3s = {
      images = [ image ];
      autoDeployCharts.hello-world = chart // {
        targetNamespace = "hello-world";
        createNamespace = true;
        values = {
          replicaCount = 1;
          image = {
            repository = image.imageName;
            tag = image.imageTag;
          };
          service = {
            type = "LoadBalancer";
            loadBalancerIP = "192.168.0.200";
            annotations = {
              "metallb.io/address-pool" = "default";
            };
          };
        };
      };
    };
  };
}
