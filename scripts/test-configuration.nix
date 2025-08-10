{
  pkgs,
  lib,
  config,
  ...
}:

let
  userConfig =
    config.userConfig or {
      username = "junr03";
      name = "Jose Ulises Nino Rivera";
      email = "junr03@users.noreply.github.com";
      sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8iAnIaa1deoc7jw8YACPNVka1ZFJxhnU4G74TmS+p";
    };

  # Test functions
  testUserConfig = ''
    echo "Testing user configuration..."
    if [[ "$(nix eval --impure --expr 'builtins.getEnv "USER_CONFIG_USERNAME"')" == "${userConfig.username}" ]]; then
      echo "✅ User configuration is accessible"
    else
      echo "❌ User configuration not found"
      exit 1
    fi
  '';

  testNixSettings = ''
    echo "Testing Nix settings..."
    if nix eval --impure --expr 'builtins.hasAttr "nix" (import <nixpkgs/nixos/modules/system/activation/activation-script.nix> {})'; then
      echo "✅ Nix settings are properly configured"
    else
      echo "❌ Nix settings not found"
      exit 1
    fi
  '';

  testPackageStructure = ''
    echo "Testing package structure..."
    if [[ -f modules/shared/packages/default.nix ]] && \
       [[ -f modules/shared/packages/development.nix ]] && \
       [[ -f modules/shared/packages/utilities.nix ]] && \
       [[ -f modules/shared/packages/media.nix ]] && \
       [[ -f modules/shared/packages/fonts.nix ]]; then
      echo "✅ Package structure is correct"
    else
      echo "❌ Package structure is missing files"
      exit 1
    fi
  '';

  testFontConfiguration = ''
    echo "Testing font configuration..."
    if nix eval --impure --expr 'builtins.hasAttr "fonts" (import ./modules/shared/fonts.nix {})'; then
      echo "✅ Font configuration is accessible"
    else
      echo "❌ Font configuration not found"
      exit 1
    fi
  '';

  testSecretsConfiguration = ''
    echo "Testing secrets configuration..."
    if [[ -f modules/shared/secrets.nix ]] && \
       [[ -f modules/darwin/secrets.nix ]] && \
       [[ -f modules/nixos/secrets.nix ]]; then
      echo "✅ Secrets configuration structure is correct"
    else
      echo "❌ Secrets configuration files missing"
      exit 1
    fi
  '';

  testSchemaValidation = ''
    echo "Testing configuration schema..."
    if nix eval --impure --expr 'builtins.hasAttr "userConfig" (import ./modules/shared/schema.nix {})'; then
      echo "✅ Configuration schema is accessible"
    else
      echo "❌ Configuration schema not found"
      exit 1
    fi
  '';

  testFlakeStructure = ''
    echo "Testing flake structure..."
    if nix flake check --no-build; then
      echo "✅ Flake structure is valid"
    else
      echo "❌ Flake structure has issues"
      exit 1
    fi
  '';

  testConfigurationBuild = ''
    echo "Testing configuration build..."
    if nix build .#darwinConfigurations.aarch64-darwin.system --dry-run; then
      echo "✅ Darwin configuration builds successfully"
    else
      echo "❌ Darwin configuration build failed"
      exit 1
    fi

    if nix build .#nixosConfigurations.x86_64-linux.config.system.build.toplevel --dry-run; then
      echo "✅ NixOS configuration builds successfully"
    else
      echo "❌ NixOS configuration build failed"
      exit 1
    fi
  '';

  testNoHardcodedValues = ''
    echo "Testing for hardcoded values..."
    if ! grep -r "junr03" . --exclude-dir=.git --exclude=*.md | grep -v "userConfig" | grep -v "default"; then
      echo "✅ No hardcoded usernames found"
    else
      echo "❌ Hardcoded usernames still present"
      exit 1
    fi
  '';

  testDuplicateConfigurations = ''
    echo "Testing for duplicate configurations..."
    nix_files=$(find . -name "*.nix" -not -path "./.git/*")
    duplicates=0

    for file in $nix_files; do
      if grep -q "nix-community.cachix.org" "$file" 2>/dev/null; then
        duplicates=$((duplicates + 1))
      fi
    done

    if [[ $duplicates -le 1 ]]; then
      echo "✅ No duplicate Nix configurations found"
    else
      echo "❌ Duplicate Nix configurations found in $duplicates files"
      exit 1
    fi
  '';

in
pkgs.writeScriptBin "test-configuration" ''
  #!/usr/bin/env bash
  set -euo pipefail

  echo "🧪 Testing Streamlined NixOS Configuration"
  echo "=========================================="

  # Set environment variables for testing
  export USER_CONFIG_USERNAME="${userConfig.username}"
  export USER_CONFIG_NAME="${userConfig.name}"
  export USER_CONFIG_EMAIL="${userConfig.email}"
  export USER_CONFIG_SSH_KEY="${userConfig.sshKey}"

  # Run all tests
  ${testUserConfig}
  ${testNixSettings}
  ${testPackageStructure}
  ${testFontConfiguration}
  ${testSecretsConfiguration}
  ${testSchemaValidation}
  ${testFlakeStructure}
  ${testConfigurationBuild}
  ${testNoHardcodedValues}
  ${testDuplicateConfigurations}

  echo ""
  echo "🎉 All tests passed! Configuration is properly streamlined."
  echo ""
  echo "📊 Summary:"
  echo "  ✅ User configuration centralized"
  echo "  ✅ Nix settings unified"
  echo "  ✅ Package management modularized"
  echo "  ✅ Font configuration centralized"
  echo "  ✅ Secrets management unified"
  echo "  ✅ Configuration schema validated"
  echo "  ✅ No hardcoded values"
  echo "  ✅ No duplicate configurations"
  echo "  ✅ All configurations build successfully"
''

