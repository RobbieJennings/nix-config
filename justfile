# List all the just commands
# Usage: $ just
default:
  @just --list

# List all system configurations
# Usage: $ just list-systems
list-systems:
  nix flake show | grep "NixOS configuration" | sed 's/[─│├└: ]*//g' | sed 's/NixOSconfiguration//g'

# List all secret files
# Usage: $ just list-secrets
list-secrets:
  ls secrets | sed 's/.yaml//g'

# Run flake checks
# Usage: $ just check
check:
  nix flake check

# Update flake lockfile
# Usage: $ just update
update:
  nix flake update

# Format flake
# Usage: $ just format
format:
  nix fmt

# Switch to a new configuration without adding boot menu entry
# Usage: $ sudo just test
test system:
  nixos-rebuild test --flake .#{{system}} --show-trace --verbose

# Deploy a specific host
# Usage: $ sudo just deploy <system>
deploy system:
  nixos-rebuild switch --flake .#{{system}}

# Rebuild current system
# Usage: $ sudo just rebuild
rebuild:
  nixos-rebuild switch --flake .

# Generate age key for user
# Usage: $ just generate-user-age
generate-user-age:
  mkdir -p ~/.config/sops/age
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt

# Generate age key for root
# Usage: $ sudo just generate-root-age
generate-root-age:
  mkdir -p /root/.config/sops/age
  ssh-to-age -private-key -i /root/.ssh/id_ed25519 > /root/.config/sops/age/keys.txt

# Edit SOPS encrypted file in secrets directory
# Usage: $ (sudo) just edit-secret <secret>
edit-secret secret:
  sops edit ./secrets/{{secret}}.yaml

# Generate docs
# Usage: $ just docs
docs:
  mkdir -p docs
  nix build .#nixos-options-doc && cat result/nixos-options-doc.md > ./docs/nixos-options.md && rm -r result
  nix build .#home-manager-options-doc && cat result/home-manager-options-doc.md > ./docs/home-manager-options.md && rm -r result

# Generate git-hooks
# Usage: $ just hooks
hooks:
  nix develop .#hooks

# Open nix repl
# Usage: $ just repl
repl:
  nix repl -f flake:nixpkgs

# Print version history
# Usage: $ just history
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Remove all generations older than 7 days
# Usage: $ sudo just clean
clean:
  nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# Garbage collect all unused nix store entries
# Usage: $ sudo just gc
gc:
  nix-collect-garbage --delete-old
