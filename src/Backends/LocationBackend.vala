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

public class Privacy.Backends.Location : Privacy.AbstractBackend {
    public override string ICON_NAME { get { return "find-location-symbolic"; } }
    private const string BACKEND_NAME = _("Location");

    private const string GEOCLUE_BUS_NAME = "org.freedesktop.GeoClue2";
    private const string GEOCLUE_MANAGER_BUS_PATH = "/org/freedesktop/GeoClue2/Manager";

    private Widgets.AppList app_list_widget;

    public Location () {
        app_list_widget = new Widgets.AppList (BACKEND_NAME);
    }

    public override Gtk.Widget get_app_list () {
        return app_list_widget;
    }

    public override void added () {
        Bus.watch_name (BusType.SYSTEM, GEOCLUE_BUS_NAME, BusNameWatcherFlags.NONE, on_geoclue_start, on_geoclue_stop);
    }

    public override void update_app_list () {
        app_list_widget.clear_apps ();

        var manager = Bus.get_proxy_sync <Services.DBusInterfaces.GeoclueManager> (BusType.SYSTEM, GEOCLUE_BUS_NAME, GEOCLUE_MANAGER_BUS_PATH);
        var ids = manager.GetClientList ();
        foreach (var id in ids) {
            var app_info = new DesktopAppInfo (id + ".desktop");
            app_list_widget.add_app (app_info);
        }
    }

    private void on_geoclue_start (DBusConnection conn) {
        activated ();
    }

    private void on_geoclue_stop (DBusConnection conn) {
        deactivated ();
    }
}
