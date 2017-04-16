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

public class Privacy.Backends.Camera : Privacy.AbstractBackend {
    public override string ICON_NAME { get { return "camera-video-symbolic"; } }

    public override void get_menu_items () { }

    public override void added () {
        Timeout.add (1000, () => {
            if (check_camera_in_use ()) {
                activated ();
            } else {
                deactivated ();
            }
            return true;
        });
    }

    private bool check_camera_in_use () {
        string standard_output;
        Process.spawn_command_line_sync ("lsof /dev/video0", out standard_output);
        if (standard_output.length == 0) {
            return false;
        } else {
            return true;
        }
    }
}
