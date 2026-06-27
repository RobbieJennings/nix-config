{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.alloy-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      alloyImage = pkgs.dockerTools.pullImage {
        imageName = "grafana/alloy";
        imageDigest = "sha256:41c41849989b7e054ccbadc17938ee1e5592fe26bfbc56ef3ffc109c0b0b2739";
        hash = "sha256-bXCrfjwt+NB1rSq48gl7SNrwZ7UFxB7/CWtUyLISJf4=";
        finalImageTag = "v1.17.0";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.monitoring.alloy.enable {
        services.k3s.images = [ alloyImage ];
      };
    };
}
