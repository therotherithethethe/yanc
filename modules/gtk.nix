{pkgs, inputs,  ...}:

{
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra; 
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita";
    };
  };

  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
  };
}
