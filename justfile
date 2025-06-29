# Deploy to a specific host
# Usage: $ just deploy host <host name>
deploy host:
  sudo nixos-rebuild switch --flake .#{{host}}