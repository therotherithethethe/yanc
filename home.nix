# /etc/nixos/home.nix (ВРЕМЕННЫЙ)
{ pkgs, inputs, ... }:

{
  imports = [ 
    ./modules/hyprland.nix
    ./modules/git.nix
  ];
  home.stateVersion = "25.05";
  programs.btop.enable = true;
  programs.kitty.enable = true;
  programs.wofi.enable = true;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  home.pointerCursor.hyprcursor.enable = true;
}
