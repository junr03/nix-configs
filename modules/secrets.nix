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
    "/Users/${user}/.age/identities/yubikey_5c.txt"
    "/Users/${user}/.age/identities/yubikey_5c_nano.txt"
    "/Users/${user}/.age/identities/yubikey_5c_nfc.txt"
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
