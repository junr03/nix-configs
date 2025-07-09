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
  system.activationScripts.extraActivation.text = ''
    # Configure iTerm2 automatically on system rebuild
    if [ -f /Users/${user}/.config/iterm2/configure-iterm2.applescript ]; then
      echo "Configuring iTerm2..."
      sudo -u ${user} osascript /Users/${user}/.config/iterm2/configure-iterm2.applescript 2>/dev/null || true
      echo "iTerm2 configuration applied"
    fi
  '';

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

  # Additional system configuration for display resolution
  system.activationScripts.displayConfig.text = ''
    # Set display resolution to 2560x1440 (scaled)
    echo "Configuring display resolution..."
    
    # Use displayplacer (installed via Homebrew) to set display resolution
    if command -v displayplacer >/dev/null 2>&1; then
      displayplacer "id:1 res:2560x1440 hz:60 color_depth:8 scaling:on origin:(0,0) degree:0" 2>/dev/null || true
      echo "Display resolution set to 2560x1440 (scaled)"
    else
      echo "displayplacer not found - will be installed via Homebrew on next build"
      echo "Manual setup: System Preferences > Displays > Scaled > 2560x1440"
    fi
  '';
}
