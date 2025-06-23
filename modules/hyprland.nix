{ pkgs, config, inputs, lib, ... }:

{
  xdg.portal = {
    enable = lib.mkForce true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland # For screen sharing and compositor features
      pkgs.xdg-desktop-portal-gtk      # For theming, icons, and file pickers
    ];
  };
    wayland.windowManager.hyprland = {
    enable = true;
    package = null; 
    portalPackage = null;
    systemd.enable = false;
    extraConfig = ''
      ${builtins.readFile ./hyprland.conf}
    '';
    settings = {
      "$mod" = "SUPER";
      
      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, Q, killactive,"
        "$mod, D, exec, wofi --show drun"
      ];
    };
  };
}
