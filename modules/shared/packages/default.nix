{ pkgs }:
with pkgs;
let
  development = import ./development.nix { inherit pkgs; };
  utilities = import ./utilities.nix { inherit pkgs; };
  media = import ./media.nix { inherit pkgs; };
  fonts = import ./fonts.nix { inherit pkgs; };
in
development ++ utilities ++ media ++ fonts

