{ lib, runCommand, nixosOptionsDoc, ... }:

 let
    eval = lib.evalModules {
      modules = [
        ({ _module.check = false; })
        ../modules/nixos/core
      ];
    };
    optionsDoc = nixosOptionsDoc {
      inherit (eval) options;
    };
in
    runCommand "OPTIONS.md" {} ''
      cat ${optionsDoc.optionsCommonMark} >> $out
    ''