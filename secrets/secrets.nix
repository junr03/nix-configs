let
  nix-configs-identity-pub-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJJiMIB5tmAtls2/Z9KhLKA9BrMSUlSHHsPW73clu2a inbox@junr03.com";
in
{
  "electricpeak-ssh-key.age".publicKeys = [ nix-configs-identity-pub-key ];
  "github-ssh-key.age".publicKeys = [ nix-configs-identity-pub-key ];
  "test.age".publicKeys = [ nix-configs-identity-pub-key ];
}
