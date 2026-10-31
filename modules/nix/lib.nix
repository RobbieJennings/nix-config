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
      let
        matches = lib.filter (image: image ? imageName && image.imageName == imageName) imageList;
      in
      if matches == [ ] then
        throw "findImageByName: no image named '${imageName}'"
      else if lib.length (lib.tail matches) > 0 then
        throw "findImageByName: more than one image name '${imageName}'"
      else
        lib.head matches;
  };
}
