{
  lib,
  runCommand,
  nixosOptionsDoc,
  ...
}:

let
  eval = lib.evalModules {
    modules = [
      { _module.check = false; }
      ../modules/home-manager/cosmic-manager
      ../modules/home-manager/development
      ../modules/home-manager/gaming
      ../modules/home-manager/photography
      ../modules/home-manager/plasma-manager
      ../modules/home-manager/secrets
      ../modules/home-manager/utilities
      ../modules/home-manager/web
    ];
  };
  cleanEval = lib.filterAttrsRecursive (n: v: n != "_module") eval;
  optionsDoc = nixosOptionsDoc { inherit (cleanEval) options; };
in
runCommand "OPTIONS.md" { } ''
  cat ${optionsDoc.optionsCommonMark} >> $out
''
