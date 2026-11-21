{
  inputs,
  ...
}:
{
  perSystem =
    {
      self',
      system,
      pkgs,
      ...
    }:
    {
      devShells.hooks = pkgs.mkShell {
        buildInputs = self'.checks.pre-commit-check.enabledPackages;
        shellHook = ''
          ${self'.checks.pre-commit-check.shellHook}
          exit
        '';
      };
    };
}
