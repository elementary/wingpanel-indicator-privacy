/*
 * Copyright (c) 2011-2017 elementary LLC. (https://launchpad.net/wingpanel)
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
 * Boston, MA 02110-1301 USA.
 */

public class Privacy.Widgets.AppList : Gtk.Revealer {
    private string title;
    private Gtk.Grid main_grid;
    private Gee.HashSet<AppListRow> app_list;

    public AppList (string title) {
        main_grid = new Gtk.Grid ();
        main_grid.orientation = Gtk.Orientation.VERTICAL;
        app_list = new Gee.HashSet<AppListRow> ();

        add (main_grid);

        this.title = title;
        update_list ();
    }

    private void clear_grid () {
        foreach (var child in main_grid.get_children ()) {
            main_grid.remove (child);
        }
    }

    private void update_list () {
        clear_grid ();

        var title_label = new Gtk.Label (_("Apps Using %s").printf (title));
        title_label.get_style_context ().add_class ("h4");
        title_label.halign = Gtk.Align.START;
        title_label.margin_start = 12;
        title_label.margin_end = 12;
        title_label.margin_bottom = 6;
        title_label.hexpand = true;

        main_grid.add (title_label);

        foreach (var app in app_list) {
            main_grid.add (app);
        }

        var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
            margin_top = 3,
            margin_bottom = 3
        };
        main_grid.add (separator);
        main_grid.show_all ();
        if (app_list.size > 0) {
            set_reveal_child (true);
        } else {
            set_reveal_child (false);
        }
    }

    public void add_app (AppInfo app) {
        var row = new AppListRow.from_appinfo (app);
        if (app_list.add (row)) {
            update_list ();
        }
    }

    public void add_unknown_app (string? label = null) {
        var row = new AppListRow.with_label (label);
        if (app_list.add (row)) {
            update_list ();
        }
    }

    public void clear_apps () {
        app_list.clear ();
        update_list ();
    }

}
