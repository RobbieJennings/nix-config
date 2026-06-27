{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      forgejoImage = pkgs.dockerTools.pullImage {
        imageName = "code.forgejo.org/forgejo/forgejo";
        imageDigest = "sha256:e7a59d193ad5e8bde19cffc68f26ee00e77a5b0014e95433eed5038f0c3888da";
        hash = "sha256-YV2c6vjgEyo5RQelYJYyb2EuE6enVRQ9PWAIXRHKny0=";
        finalImageTag = "15.0.3-rootless";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.forgejo.enable {
        services.k3s.images = [ forgejoImage ];
      };
    };
}
