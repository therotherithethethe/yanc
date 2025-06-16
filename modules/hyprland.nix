{ pkgs, config, inputs, ... }:

{
    wayland.windowManager.hyprland = {
    enable = true;
    package = null; 
    portalPackage = null;
    systemd.enable = false;
    
    settings = {
      "$mod" = "SUPER";
      
      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, Q, killactive,"
        "$mod, D, exec, wofi --show-drun"
      ];
    };
  };
}
