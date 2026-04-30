{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.node-feature-discovery-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      nodeFeatureDiscoveryImage = pkgs.dockerTools.pullImage {
        imageName = "registry.k8s.io/nfd/node-feature-discovery";
        imageDigest = "sha256:f9ef2ebee55141a1758d3c0a87bb701f5db2adf6856f7218b11bc2bac7b63862";
        sha256 = "sha256-UhEuAzcNHLFZ88FJcLMMnXHxzhmwR1gYPD6F9yKhnT8=";
        finalImageTag = "v0.18.3";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.node-feature-discovery.enable {
        services.k3s = {
          images = [ nodeFeatureDiscoveryImage ];
          autoDeployCharts.node-feature-discovery.values = {
            image = {
              repository = nodeFeatureDiscoveryImage.imageName;
              tag = nodeFeatureDiscoveryImage.imageTag;
            };
          };
        };
      };
    };
}
