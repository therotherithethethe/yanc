{ pkgs, config, inputs, lib, ... }:

{
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
