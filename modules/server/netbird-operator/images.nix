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
        imageName = "netbirdio/kubernetes-operator";
        imageDigest = "sha256:57740157b4d7c0ce1356f6c1c3cc0f4c6573600eadbee642334b3070fb51899a";
        sha256 = "sha256-bnpB50R8k6POBq+IuZ9UpA0qdw6qhEmIoQXx9EzYrbY=";
        finalImageTag = "0.3.1";
        arch = "amd64";
      };
      routerImage = pkgs.dockerTools.pullImage {
        imageName = "netbirdio/netbird";
        imageDigest = "sha256:b1487a94f432aa706275ebbbbdff3605bf927b056d63855f3d43966cb68c64dc";
        sha256 = "sha256-fMR/IP3PM/fQfYkl+IeoTWkp++oFY9NGu7MP/qb29W8=";
        finalImageTag = "0.70.0-rootless";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.netbird-operator.enable {
        services.k3s = {
          images = [
            operatorImage
            routerImage
          ];
          autoDeployCharts.netbird-operator.values = {
            operator.image = {
              repository = operatorImage.imageName;
              tag = operatorImage.imageTag;
            };
            routingClientImage = "${routerImage.imageName}:${routerImage.imageTag}";
          };
        };
      };
    };
}
