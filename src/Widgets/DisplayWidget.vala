/*
* Copyright (c) 2016-2017 elementary LLC. (http://launchpad.net/wingpanel-indicator-sound)
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
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

public class Privacy.Widgets.DisplayWidget : Gtk.Box {
    private const int ICON_SPACING = 16;

    public signal void visibility_changed ();

    private Gee.ArrayList<Gtk.Revealer> revealers;

    construct {
        revealers = new Gee.ArrayList<Gtk.Revealer> ();
    }

    public void add_backend (AbstractBackend backend) {
        var revealer = new Gtk.Revealer ();
        revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_RIGHT;
        revealers.add (revealer);

        var icon = new Gtk.Image ();
        icon.icon_name = backend.ICON_NAME;
        icon.icon_size = Gtk.IconSize.LARGE_TOOLBAR;

        revealer.add (icon);
        add (revealer);

        backend.activated.connect (() => {
            revealer.set_reveal_child (true);
            visibility_changed ();
            update_padding ();
        });

        backend.deactivated.connect (() => {
            revealer.set_reveal_child (false);
            visibility_changed ();
            update_padding ();
        });

        backend.added ();
    }

    public bool has_visible_icons () {
        foreach (var revealer in revealers) {
            if (revealer.get_reveal_child ()) {
                return true;
            }
        }
        return false;
    }

    private void update_padding () {
        foreach (var revealer in revealers) {
            revealer.get_child ().margin_start = 0;
        }

        if (revealers.size <= 1) {
            return;
        }

        for (int i = 1; i < revealers.size; i++) {
            for (int j = 0; j < i; j++) {
                if (revealers[j].get_reveal_child ()) {
                    revealers[i].get_child ().margin_start = ICON_SPACING;
                    break;
                }
            }
        }
    }
}
