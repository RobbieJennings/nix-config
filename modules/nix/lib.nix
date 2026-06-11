{
  inputs,
  lib,
  ...
}:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    findImageByName =
      imageName: imageList:
      (lib.lists.findSingle (x: x ? imageName && x.imageName == imageName) null null imageList);
  };
}
