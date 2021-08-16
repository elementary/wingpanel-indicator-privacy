/*
 * Copyright (c) 2011-2017 elementary LLC. (http://launchpad.net/wingpanel)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 */

public class Privacy.Indicator : Wingpanel.Indicator {
    private Widgets.DisplayWidget? indicator_icon = null;
    private Gtk.ModelButton settings;

    private Gee.ArrayList<AbstractBackend> backends;

    private Gtk.Grid main_grid;

    public Indicator () {
        GLib.Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        GLib.Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");

        Object (code_name: Wingpanel.Indicator.PRIVACY,
                visible: false);

        backends = new Gee.ArrayList<AbstractBackend> ();
        backends.add (new Backends.Location ());
        backends.add (new Backends.Camera ());
    }

    public override Gtk.Widget get_display_widget () {
        if (indicator_icon == null) {
            indicator_icon = new Widgets.DisplayWidget ();

            foreach (var backend in backends) {
                indicator_icon.add_backend (backend);
            }

            indicator_icon.visibility_changed.connect (() => {
                var has_icons = indicator_icon.has_visible_icons ();
                if (has_icons != visible) {
                    visible = has_icons;
                }
            });
        }

        return indicator_icon;
    }

    public override Gtk.Widget? get_widget () {
        if (main_grid == null) {
            main_grid = new Gtk.Grid ();
            main_grid.set_orientation (Gtk.Orientation.VERTICAL);

            settings = new Gtk.ModelButton () {
                text = _("Privacy Settings…")
            };

            foreach (var backend in backends) {
                main_grid.add (backend.get_app_list ());
            }
            main_grid.add (settings);

            settings.clicked.connect (() => {
                close ();
                show_settings ();
            });
        }

        return main_grid;
    }

    private void show_settings () {
        try {
            AppInfo.launch_default_for_uri ("settings://security/privacy", null);
        } catch (Error e) {
            warning ("%s", e.message);
        }
    }

    public override void opened () {
        foreach (var backend in backends) {
            backend.update_app_list ();
        }
    }

    public override void closed () {}
}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        return null;
    }

    debug ("Activating Privacy Indicator");
    var indicator = new Privacy.Indicator ();

    return indicator;
}
