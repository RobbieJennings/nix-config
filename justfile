# List all the just commands
# Usage: $ just
default:
  @just --list

# Deploy a specific host
# Usage: $ sudo just deploy host <host name>
deploy host:
  nixos-rebuild switch --flake .#{{host}}

# Rebuild current system
# Usage: $ sudo just rebuild
rebuild:
  nixos-rebuild switch --flake .

# Debug flake for current system
# Usage: $ sudo just debug
debug:
  nixos-rebuild test --flake . --show-trace --verbose

# Run flake checks
# Usage: $ sudo just check
check:
  nix flake check

# Update flake lockfile
# Usage: $ just update
update:
  nix flake update

# Print version history
# Usage: $ just history
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open nix repl
# Usage: $ just repl
repl:
  nix repl -f flake:nixpkgs

# Remove all generations older than 7 days
# Usage: $ sudo just clean
clean:
  nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# Garbage collect all unused nix store entries
# Usage: $ sudo just gc
gc:
  nix-collect-garbage --delete-old