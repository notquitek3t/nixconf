{ pkgs, ... }: {
  gtk = {
    enable = true;
    colorScheme = "dark";
    cursorTheme = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
    };
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
    gtk3 = {
      enable = true;
      colorScheme = "dark";
    };
    gtk4 = {
      enable = true;
      colorScheme = "dark";
    };
  };
}