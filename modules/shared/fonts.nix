{
  config,
  pkgs,
  lib,
  ...
}:

{
  fonts.packages = with pkgs; [
    # Core fonts
    dejavu_fonts
    fira-code
    nerd-fonts.fira-code
    jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-emoji

    # Custom fonts from overlays
    feather-font
  ];
}

