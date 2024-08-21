{ inputs, outputs, ... }:

{
  additions = final: _prev: import ../pkgs final.pkgs;

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = final.config.allowUnfree;
    };
  };

  modifications = final: prev: {

  };
}
