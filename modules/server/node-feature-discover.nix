{
  inputs,
  ...
}:
{
  flake.modules.nixos.node-feature-discovery =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "node-feature-discovery";
        repo = "oci://registry.k8s.io/nfd/charts/node-feature-discovery";
        version = "0.18.3";
        hash = "sha256-g6MnrWFUW8ibMZ6U9RdepNJlybb/qigyryoKhTiUCd4=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "registry.k8s.io/nfd/node-feature-discovery";
        imageDigest = "sha256:f9ef2ebee55141a1758d3c0a87bb701f5db2adf6856f7218b11bc2bac7b63862";
        sha256 = "sha256-UhEuAzcNHLFZ88FJcLMMnXHxzhmwR1gYPD6F9yKhnT8=";
        finalImageTag = "v0.18.3";
        arch = "amd64";
      };
    in
    {
      options = {
        node-feature-discovery.enable = lib.mkEnableOption "Node Feature Discovery";
      };

      config = lib.mkIf config.node-feature-discovery.enable {
        services.k3s = {
          images = [ image ];
          autoDeployCharts.node-feature-discovery = chart // {
            targetNamespace = "node-feature-discovery";
            createNamespace = true;
            values = {
              image = {
                repository = image.imageName;
                tag = image.imageTag;
              };
              master = {
                resources = {
                  requests.cpu = "10m";
                  requests.memory = "32Mi";
                  limits.cpu = "100m";
                  limits.memory = "64Mi";
                };
              };
              worker = {
                resources = {
                  requests.cpu = "10m";
                  requests.memory = "32Mi";
                  limits.cpu = "100m";
                  limits.memory = "64Mi";
                };
              };
              gc = {
                resources = {
                  requests.cpu = "5m";
                  requests.memory = "16Mi";
                  limits.cpu = "50m";
                  limits.memory = "32Mi";
                };
              };
            };
          };
        };
      };
    };
}
