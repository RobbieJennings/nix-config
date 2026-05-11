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
      devShells = {
        default = pkgs.mkShell {
          buildInputs = self'.checks.pre-commit-check.enabledPackages;
          shellHook = ''
            ${self'.checks.pre-commit-check.shellHook}
            exit
          '';
        };
      };
    };
}
