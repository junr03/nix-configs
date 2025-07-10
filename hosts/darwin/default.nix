{
  agenix,
  config,
  pkgs,
  ...
}:

let
  user = "junr03";
in

{

  imports = [
    ../../modules/darwin/secrets.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    agenix.darwinModules.default
  ];

  # Setup user, packages, programs
  nix = {
    package = pkgs.nix;

    settings = {
      trusted-users = [
        "@admin"
        "${user}"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes

  # Load configuration that is shared across systems
  environment.systemPackages =
    with pkgs;
    [
      agenix.packages."${pkgs.system}".default
    ]
    ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  # Font configuration
  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-code
  ];

  # System activation scripts
  system.activationScripts = {
    iTerm2 = {
      text = ''
        # Configure iTerm2 automatically on system rebuild
        if [ -f /Users/${user}/.config/iterm2/configure-iterm2.applescript ]; then
          echo "Configuring iTerm2..."
          sudo -u ${user} osascript /Users/${user}/.config/iterm2/configure-iterm2.applescript 2>/dev/null || true
          echo "iTerm2 configuration applied"
        fi
      '';
      deps = [ "homebrew" ];
    };

    rosetta2 = {
      text = ''
        # Install Rosetta 2 if not already installed
        if ! /usr/bin/pgrep -q oahd; then
          echo "Installing Rosetta 2..."
          sudo softwareupdate --install-rosetta --agree-to-license
          echo "Rosetta 2 installed"
        else
          echo "Rosetta 2 is already installed"
        fi
      '';
      deps = [ "homebrew" ];
    };

    manageCasks = {
      text = ''
        echo "Managing Homebrew casks..."

        # Current casks that should be installed (from your nix config)
        DESIRED_CASKS="${builtins.concatStringsSep " " (import ../../modules/darwin/casks.nix { })}"

        # Get currently installed casks
        INSTALLED_CASKS=$(brew list --cask 2>/dev/null || echo "")

        # Create state directory if it doesn't exist
        mkdir -p /etc/nix-darwin/state
        CASK_STATE_FILE="/etc/nix-darwin/state/managed-casks"

        # Read previously managed casks
        PREVIOUS_CASKS=""
        if [ -f "$CASK_STATE_FILE" ]; then
          PREVIOUS_CASKS=$(cat "$CASK_STATE_FILE")
        fi

        # Find casks to uninstall (were managed before but not in current list)
        if [ -n "$PREVIOUS_CASKS" ]; then
          for cask in $PREVIOUS_CASKS; do
            if ! echo "$DESIRED_CASKS" | grep -q "\b$cask\b"; then
              echo "Uninstalling removed cask: $cask"
              brew uninstall --cask "$cask" 2>/dev/null || echo "Failed to uninstall $cask (may not be installed)"
            fi
          done
        fi

        # Update the state file with current desired casks
        echo "$DESIRED_CASKS" > "$CASK_STATE_FILE"

        echo "Cask management complete"
      '';
      deps = [ "homebrew" ];
    };
  };

  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 4;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 96;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };
}
