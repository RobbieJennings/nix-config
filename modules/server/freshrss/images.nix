{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.freshrss-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      freshrss-image = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/freshrss";
        imageDigest = "sha256:699594b0bccd029e655052e18d69abd235dd5ddc071f44f3af3b407f01138954";
        hash = "sha256-uN38aSJbe96vpKYwTmP25Pk87b+x2H1PBzosad9fo0U=";
        finalImageTag = "1.29.1";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.freshrss.enable {
        services.k3s = {
          images = [ freshrss-image ];
        };
      };
    };
}
