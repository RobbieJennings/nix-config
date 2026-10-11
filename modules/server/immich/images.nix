{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.immich-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      immichImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/immich-app/immich-server";
        imageDigest = "sha256:db996e352359771c6a3db121a0ed8761516b22f727fc092a0f46dcfef82c1bc1";
        hash = "sha256-1bHUAMpOAKnzImDWv976PWQkojYQqd1UU+D5QdO0frM=";
        finalImageTag = "v3.3.1";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.immich.enable {
        services.k3s = {
          images = [ immichImage ];
        };
      };
    };
}
