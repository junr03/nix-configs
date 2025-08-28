{
  config,
  pkgs,
  agenix,
  secrets,
  ...
}:

let
  user = "junr03";
in
{
  age.identityPaths = [
    "../secrets/identity.txt"
  ];

  # age.secrets."github-ssh-key" = {
  #   symlink = true;
  #   path = "/Users/${user}/.ssh/id_github";
  #   file =  "${secrets}/github-ssh-key.age";
  #   mode = "600";
  #   owner = "${user}";
  #   group = "staff";
  # };

  # age.secrets."github-signing-key" = {
  #   symlink = false;
  #   path = "/Users/${user}/.ssh/pgp_github.key";
  #   file =  "${secrets}/github-signing-key.age";
  #   mode = "600";
  #   owner = "${user}";
  # };

}
