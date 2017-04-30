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

public class Privacy.Widgets.AppListRow : Gtk.Grid {
    private Gtk.Image icon;
    private Gtk.Label label;
    private bool appinfo_constructor = false;
    private string appinfo_id;

    private const string UNKNOWN_APP_TEXT = _("Unknown Application");

    construct {
        column_spacing = 6;
        margin_start = 12;
        margin_end = 12;
        margin_bottom = 6;
    }

    public AppListRow.from_appinfo (AppInfo app) {
        appinfo_constructor = true;
        appinfo_id = app.get_id ();

        var app_icon = app.get_icon ();
        var app_name = app.get_name ();

        if (app_icon == null) {
            icon = new Gtk.Image.from_icon_name ("application-default-icon", Gtk.IconSize.LARGE_TOOLBAR);
        } else {
            icon = new Gtk.Image.from_gicon (app_icon, Gtk.IconSize.LARGE_TOOLBAR);
        }

        if (app_name == null) {
            label = new Gtk.Label (UNKNOWN_APP_TEXT);
        } else {
            label = new Gtk.Label (app_name);
        }

        icon.pixel_size = 24;
        label.halign = Gtk.Align.START;

        attach (icon, 0, 0, 1, 1);
        attach (label, 1, 0, 1, 1);
    }

    public AppListRow.with_label (string? label_text = null) {
        icon = new Gtk.Image.from_icon_name ("application-default-icon", Gtk.IconSize.LARGE_TOOLBAR);
        if (label_text != null) {
            label = new Gtk.Label (label_text);
        } else {
            label = new Gtk.Label (UNKNOWN_APP_TEXT);
        }
        
        icon.pixel_size = 24;
        label.halign = Gtk.Align.START;

        attach (icon, 0, 0, 1, 1);
        attach (label, 1, 0, 1, 1);
    }

    public bool equal (AppListRow b) {
        if (appinfo_constructor == b.appinfo_constructor) {
            if (appinfo_constructor) {
                if (appinfo_id == b.appinfo_id) {
                    return true;
                }
            } else {
                if (label.label == b.label.label) {
                    return true;
                }
            }
        } else {
            return false;
        }

        return false;
    }

    public uint hash () {
        string hash_string = "";
        hash_string += appinfo_constructor.to_string ();
        hash_string += appinfo_id;
        hash_string += label.label;
        if (icon.gicon != null) {
            hash_string += icon.gicon.to_string ();
        } else {
            hash_string += icon.icon_name;
        }
        return hash_string.hash ();
    }
}
