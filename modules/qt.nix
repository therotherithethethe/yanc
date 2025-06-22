
{ pkgs, config, inputs, ... }:

{
  qt = {
    enable = true;
    platformTheme = "qtct"; # Use qtct to control Qt5/6 styles
    style = {
      name = "kvantum"; # Kvantum is a theme engine that can mimic GTK themes beautifully
      package = pkgs.kvantum;
    };
  };

  gtk = {
    enable = true;
    # Use the Catppuccin-Mocha theme (dark blue variant)
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ]; # You can choose other colors like "mauve", "green", etc.
        variant = "mocha";   # Or "macchiato", "frappe", "latte"
      };
    };

    # Set the icon theme to match
    iconTheme = {
      name = "Papirus-Dark"; # Papirus is a great general-purpose icon set
      package = pkgs.papirus-icon-theme;
    };
  };
}
