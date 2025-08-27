{ user, pkgs, config, ... }:

let
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome = "${config.users.users.${user}.home}/.local/state";
  # githubPublicKey = "ssh-ed25519 AAAA...";
in
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
