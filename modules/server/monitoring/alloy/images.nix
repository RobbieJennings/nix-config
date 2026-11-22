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
      alloyImages = {
        alloyImage = pkgs.dockerTools.pullImage {
          imageName = "grafana/alloy";
          imageDigest = "sha256:2aa2099af76c0098d4af7a4d6e48f86cb66dc1a000222ad927a1c67c6542d13f";
          hash = "sha256-Sq0EhPJaumWzPytwNjmLEBlS+CTMuGDB6f0LexWphgQ=";
          finalImageTag = "v1.20.1";
          arch = "amd64";
        };
      };
    in
    {
      config = {
        _module.args.alloyImages = alloyImages;
        services.k3s = lib.mkIf config.monitoring.alloy.enable {
          images = builtins.attrValues alloyImages;
        };
      };
    };
}
