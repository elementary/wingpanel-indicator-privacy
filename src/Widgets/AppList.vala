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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

public class Privacy.Widgets.AppList : Gtk.Revealer {
    private string title;
    private Gtk.Grid main_grid;
    private Gee.HashSet<AppInfo> app_list;

    public AppList (string title) {
        hexpand = true;
        main_grid = new Gtk.Grid ();        
        main_grid.orientation = Gtk.Orientation.VERTICAL;
        app_list = new Gee.HashSet<AppInfo>((v) => {
            return v.get_id ().hash ();
        },
        (a, b) => {
            return a.get_id () == b.get_id ();
        });

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

        main_grid.add (title_label);

        foreach (var app in app_list) {
            var app_icon = app.get_icon ();
            var app_name = app.get_name ();

            if (app_icon == null || app_name == null) {
                return;
            }

            var grid = new Gtk.Grid ();
            grid.column_spacing = 6;
            grid.margin_start = 12;
            grid.margin_end = 12;
            grid.margin_bottom = 6;

            var app_icon_image = new Gtk.Image.from_gicon (app_icon, Gtk.IconSize.LARGE_TOOLBAR);
            app_icon_image.pixel_size = 24;

            var app_name_label = new Gtk.Label (app_name);
            app_name_label.halign = Gtk.Align.START;

            grid.attach (app_icon_image, 0, 0, 1, 1);
            grid.attach (app_name_label, 1, 0, 1, 1);

            main_grid.add (grid);
        }

        main_grid.add (new Wingpanel.Widgets.Separator ());
        main_grid.show_all ();
        if (app_list.size > 0) {
            set_reveal_child (true);
        }
    }

    public void add_app (AppInfo app) {
        if (app_list.add (app)) {
            update_list ();
        }
    }

    public void remove_app (AppInfo app) {
        if (app_list.remove (app)) {
            update_list ();
        }
        if (app_list.size == 0) {
            set_reveal_child (false);
        }
    }

    public void clear_apps () {
        app_list.clear ();
    }

}
