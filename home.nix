# /etc/nixos/home.nix (ВРЕМЕННЫЙ)
{ pkgs, inputs, ... }:

{
  imports = [ 
    ./modules/hyprland.nix
    ./modules/git.nix
  ];
  home.stateVersion = "25.05";
}
