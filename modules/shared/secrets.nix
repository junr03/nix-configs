{
  config,
  pkgs,
  lib,
  agenix,
  secrets,
  ...
}:

let
  user = config.userConfig.username or "junr03";
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  homePath = if isDarwin then "/Users/${user}" else "/home/${user}";
  group = if isDarwin then "staff" else "wheel";
in
{
  age.identityPaths = [
    "${homePath}/.ssh/id_ed25519"
  ];

  # Common secrets configuration
  # Uncomment and customize as needed:

  # age.secrets."github-ssh-key" = {
  #   symlink = true;
  #   path = "${homePath}/.ssh/id_github";
  #   file = "${secrets}/github-ssh-key.age";
  #   mode = "600";
  #   owner = "${user}";
  #   group = "${group}";
  # };

  # age.secrets."github-signing-key" = {
  #   symlink = false;
  #   path = "${homePath}/.ssh/pgp_github.key";
  #   file = "${secrets}/github-signing-key.age";
  #   mode = "600";
  #   owner = "${user}";
  #   group = "${group}";
  # };
}

