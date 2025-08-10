{ pkgs }:
with pkgs;
[
  # Development tools
  gitAndTools.gitFull
  nodejs
  nodePackages.npm
  nodePackages.prettier
  python3
  virtualenv
  nixfmt-rfc-style
  zsh-powerlevel10k

  # Build tools
  gcc
  cmake
  pkg-config

  # Cloud tools
  docker
  # docker-compose
]
