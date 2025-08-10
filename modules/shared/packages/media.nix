{ pkgs }:
with pkgs;
[
  # Media tools
  ffmpeg

  # Spell checking
  aspell
  aspellDicts.en
  hunspell

  # Network tools
  inetutils
  iftop
]

