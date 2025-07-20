{ pkgs, inputs, ... }:

{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  stylix = {
    image = ../carbonight.png;
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/woodland.yaml";
    fonts = {
      serif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Serif";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    targets = {
      firefox = {
        enable = true;
        profileNames = [ "diufku38.default" ];
      };
      neovim = {
        enable = true;
      };
    };
  };
}
