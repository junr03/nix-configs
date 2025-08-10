{ pkgs, userConfig, ... }:

let
  # Common script template
  mkScript =
    name: content:
    pkgs.writeScriptBin name ''
      #!/usr/bin/env bash
      set -euo pipefail

      ${content}
    '';

  # Shared scripts for all platforms
  commonScripts = {
    apply = mkScript "apply" ''
      echo "Applying configuration for $(uname -s)..."
      # Platform-specific logic will be added here
    '';

    build-switch = mkScript "build-switch" ''
      echo "Building and switching configuration..."
      # Platform-specific logic will be added here
    '';

    check-keys = mkScript "check-keys" ''
      echo "Checking SSH keys..."
      ssh-add -l || echo "No SSH keys loaded"
    '';
  };

  # Darwin-specific scripts
  darwinScripts = commonScripts // {
    build = mkScript "build" ''
      echo "Building Darwin configuration..."
      nix build .#darwinConfigurations.$(uname -m)-darwin.system
    '';

    rollback = mkScript "rollback" ''
      echo "Rolling back Darwin configuration..."
      darwin-rebuild --rollback
    '';
  };

  # Linux-specific scripts
  linuxScripts = commonScripts // {
    copy-keys = mkScript "copy-keys" ''
      echo "Copying SSH keys..."
      # Linux-specific key copying logic
    '';

    create-keys = mkScript "create-keys" ''
      echo "Creating SSH keys..."
      # Linux-specific key creation logic
    '';
  };

in
{
  darwin = darwinScripts;
  linux = linuxScripts;
}

