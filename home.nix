# /etc/nixos/home.nix (ВРЕМЕННЫЙ)
{ pkgs, inputs, ... }:

{
  imports = [ 
    ./modules/hyprland.nix
    ./modules/git.nix
    #./modules/gtk.nix
    #inputs.stylix.homeManagerModules.stylix
    ./modules/stylix.nix
  ];
  home.stateVersion = "25.05";
  programs.btop.enable = true;
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0
    };
  };
  programs.wofi.enable = true;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    #style = builtins.readFile ./modules/waybar-style.css;
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/.dotfiles/";
    };
  };
home.pointerCursor = {
  name = "Bibata-Modern-Ice";
  package = pkgs.bibata-cursors;
  size = 50;
  hyprcursor.enable = true;
};
  home.sessionVariables = {
  # This tells all Qt applications to try running on Wayland first

#    QT_QPA_PLATFORM = "wayland";
  # Fixes blurry fonts on some apps
    NIXOS_OZONE_WL = "1";
  };
  programs.vesktop.enable = true;
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = "48.72415410089862";
    longitude = "21.254198050207247";
  };
  programs.firefox = {
    enable = true;
    profiles = {
      "diufku38.default" = {
        isDefault = true;
        extensions.force = true;
      };
    };
  };
}
