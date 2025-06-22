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
home.pointerCursor = {
  name = "Bibata-Modern-Ice";
  package = pkgs.bibata-cursors;
  size = 50;
  hyprcursor.enable = true;
};
  home.sessionVariables = {
  # This tells all Qt applications to try running on Wayland first
    QT_QPA_PLATFORM = "wayland";
  # Fixes blurry fonts on some apps
    NIXOS_OZONE_WL = "1";
  };
}
