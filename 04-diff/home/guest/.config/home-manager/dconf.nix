{ ... }: {
  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    "org/gnome/mutter".dynamic-workspaces = true;
    "org/gnome/mutter".edge-tiling = true;
#    "org/gnome/settings-daemon/plugins/color".night-light-enabled = true;
#    "org/gnome/settings-daemon/plugins/color".night-light-schedule-automatic =
#      false;
#    "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type =
#      "nothing";
    "org/gnome/shell".enabled-extensions =
      [ "" "dash-to-dock@micxgx.gmail.com" ];
    "org/gnome/shell".favorite-apps = [ "firefox.desktop" ];
    "org/x/apps/portal".color-scheme = "prefer-dark";
  };
}
