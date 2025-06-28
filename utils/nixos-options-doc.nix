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
      ../modules/nixos/core
      ../modules/nixos/desktop
      ../modules/nixos/server
    ];
  };
  cleanEval = lib.filterAttrsRecursive (n: v: n != "_module") eval;
  optionsDoc = nixosOptionsDoc { inherit (cleanEval) options; };
in
runCommand "OPTIONS.md" { } ''
  cat ${optionsDoc.optionsCommonMark} >> $out
''
