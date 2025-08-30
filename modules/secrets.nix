{
  config,
  pkgs,
  agenix,
  ...
}:

let
  user = "junr03";
in
{
  age.identityPaths = [
    "/Users/${user}/.ssh/blacktail"
  ];

  age.secrets."github-ssh-key" = {
    symlink = true;
    path = "/Users/${user}/.ssh/github";
    file = ../secrets/github-ssh-key.age;
    mode = "600";
    owner = "${user}";
    group = "staff";
  };

  age.secrets."electricpeak-ssh-key" = {
    symlink = true;
    path = "/Users/${user}/.ssh/electricpeak";
    file = ../secrets/electricpeak-ssh-key.age;
    mode = "600";
    owner = "${user}";
    group = "staff";
  };
}
