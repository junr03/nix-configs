{ pkgs }:
with pkgs;
[
  # System utilities
  coreutils
  bash-completion
  bat
  btop
  htop
  killall
  neofetch
  tree
  tmux
  unzip
  zip
  wget
  unrar
  sqlite
  openssh

  # Text processing
  ripgrep
  fd
  jq

  # Security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2
]
