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
        imageDigest = "sha256:3f600513a463712aaab33cf525e20be0b5718e57da50d0ac2e092b86bcfc4812";
        hash = "sha256-qJPEuIuUrhbU3V/Idclab46l6fMoXJC5X4UhsjSozlk=";
        finalImageTag = "v0.20.0";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.node-feature-discovery.enable {
        services.k3s.images = [ nodeFeatureDiscoveryImage ];
      };
    };
}
