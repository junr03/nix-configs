let
  yubikey_5c = "age1yubikey1qt8yzdrg5tf6me6kdppcjgtnft2rls33q0qdrud3p3j0nsup9jjm29smyhp";
  yubikey_5c_nano = "age1yubikey1q0gasxft59c42dehv996kahtngdvrw298nlmyzmenwdkw8vs8aw6us6j5e2";
  yubikey_5c_nfc = "age1yubikey1q0qtk930wupw6r0apvkmm7ulkzzw67tu6mxr8xfzpzh9jdmt24c6wj6juzd";
  yubikeys = [
    yubikey_5c
    yubikey_5c_nano
    yubikey_5c_nfc
  ];
in
{
  "electricpeak-ssh-key.age".publicKeys = yubikeys;
  "github-ssh-key.age".publicKeys = yubikeys;
}
