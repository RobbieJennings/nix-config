{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  chart = {
    name = "nextcloud";
    repo = "https://nextcloud.github.io/helm";
    version = "8.7.0";
    hash = "sha256-LoEz0+iETV9kBxiRB7aML4Jzk4LhmrUQMHBQipYnWzE=";
  };
  image = pkgs.dockerTools.pullImage {
    imageName = "nextcloud";
    imageDigest = "sha256:a9ef7ed15dbf3f9fcf6dc2a41a15af572fcc077f220640cabfe574a3ffbf5766";
    sha256 = "sha256-Z9/e4KP2gH6HP+pglHpWGK0cnmReJjR1InRh8kfjUmQ=";
    finalImageTag = "32.0.3";
    arch = "amd64";
  };
in
{
  options = {
    server.nextcloud.enable = lib.mkEnableOption "nextcloud helm chart on k3s";
  };

  config = lib.mkIf config.server.nextcloud.enable {
    services.k3s = {
      images = [ image ];
      autoDeployCharts.nextcloud = chart // {
        targetNamespace = "nextcloud";
        createNamespace = true;
        values = {
          image = {
            repository = image.imageName;
            tag = image.imageTag;
          };
          service = {
            type = "LoadBalancer";
            loadBalancerIP = "192.168.0.203";
            annotations = {
              "metallb.io/address-pool" = "default";
            };
          };
        };
      };
    };
  };
}
