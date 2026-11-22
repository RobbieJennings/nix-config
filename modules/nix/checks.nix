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
    let
      checkOptionsDocs = pkgs.writeShellScript "check-options-docs" ''
        set -euo pipefail

        check_doc() {
          generated="$1"
          file="$2"

          if ! diff -u "$file" "$generated"; then
            echo "Error: $file is out of date."
            exit 1
          fi
        }

        check_doc \
          "${self'.packages.nixos-options-doc}/nixos-options-doc.md" \
          docs/nixos-options.md

        check_doc \
          "${self'.packages.home-manager-options-doc}/home-manager-options-doc.md" \
          docs/home-manager-options.md
      '';
    in
    {
      checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ../../.;
        hooks = {
          nixfmt.enable = true;
          statix.enable = true;
          nil.enable = true;
          flake-checker.enable = true;
          check-options-docs = {
            enable = true;
            name = "Check NixOS and Home Manager options documentation";
            entry = "${checkOptionsDocs}";
            pass_filenames = false;
          };
        };
      };
    };
}
