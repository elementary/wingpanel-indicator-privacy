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
    private const string ICON_NAME = "find-location-symbolic";

    private Widgets.DisplayWidget? indicator_icon = null;
    private Wingpanel.Widgets.Button settings;

    private AbstractBackend location_backend;
    private AbstractBackend camera_backend;

    private Gtk.Grid main_grid;

    public Indicator () {
        Object (code_name: "privacy",
                display_name: _("Privacy"),
                description: _("The privacy indicator"),
                visible: false);

        location_backend = new Backends.Location ();
        camera_backend = new Backends.Camera ();
    }

    public override Gtk.Widget get_display_widget () {
        if (indicator_icon == null) {
            indicator_icon = new Widgets.DisplayWidget ();

            indicator_icon.add_backend (location_backend);
            indicator_icon.add_backend (camera_backend);

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

            settings = new Wingpanel.Widgets.Button (_("Privacy Settings…"));

            main_grid.add (location_backend.get_app_list ());
            main_grid.add (camera_backend.get_app_list ());
            main_grid.add (settings);

            connections ();
        }

        this.visible = true;

        return main_grid;
    }

    public void connections () {
        settings.clicked.connect (() => {
            close ();
            show_settings ();
        });
    }

    private void show_settings () {
        try {
            Gtk.show_uri (null, "settings://security/privacy", Gdk.CURRENT_TIME);
        } catch (Error e) {
            warning ("%s\n", e.message);
        }
    }

    public override void opened () {
        ((Backends.Camera)camera_backend).update_app_list ();
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
