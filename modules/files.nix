{ pkgs, config, ... }:

# let
#  githubPublicKey = "ssh-ed25519 AAAA...";
# in
{

  # ".ssh/id_github.pub" = {
  #   text = githubPublicKey;
  # };

  # iTerm2 AppleScript configuration script
  ".config/iterm2/configure-iterm2.applescript" = {
    source = ./config/configure-iterm2.applescript;
    executable = true;
  };
}
