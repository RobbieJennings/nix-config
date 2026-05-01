{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.lidarr-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      lidarrImage = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/lidarr";
        imageDigest = "sha256:f2a186ce04ec5adb133f92a08dd3efbc918fc71b33077426ef099d94350dfa1b";
        sha256 = "sha256-IhX2Fp7rQ77jrIqefGvjFgD3huwhU3UshVQl3bbPu4c=";
        finalImageTag = "3.1.0";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf (config.media-server.enable && config.media-server.lidarr.enable) {
        services.k3s = {
          images = [ lidarrImage ];
        };
      };
    };
}
