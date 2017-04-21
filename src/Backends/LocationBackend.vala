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

    public override Gtk.Widget get_app_list () {
        return new Widgets.AppList (BACKEND_NAME);
    }

    public override void added () {
        activated ();
        Timeout.add (5000, () => {
            deactivated ();
            return false;
        });
    }
}
