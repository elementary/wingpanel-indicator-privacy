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
    private const string BACKEND_NAME = "Camera";

    private Widgets.AppList app_list_widget;
    private bool icon_visible = false;
    private string lsof_stdout;

    public Camera () {
        app_list_widget = new Widgets.AppList (BACKEND_NAME);
    }

    public override Gtk.Widget get_app_list () {
        return app_list_widget;
    }

    public override void added () {
        Timeout.add (1000, () => {
            bool in_use = check_camera_in_use ();
            update_app_list ();
            if (!icon_visible && in_use) {
                activated ();
                icon_visible = true;
            } else if (icon_visible && !in_use) {
                deactivated ();
                icon_visible = false;
            }
            return true;
        });
    }

    private bool check_camera_in_use () {
        Process.spawn_command_line_sync ("lsof /dev/video0", out lsof_stdout);
        if (lsof_stdout.length == 0) {
            return false;
        } else {
            return true;
        }
    }

    private void update_app_list () {
        app_list_widget.clear_apps ();
        Gee.ArrayList<string> added_pids = new Gee.ArrayList<string>();
        string[] lines = lsof_stdout.split ("\n");
        if (lines.length > 1) {
            for (int i = 1; i < lines.length; i++) {
                string[] cols = lines[i].split (" ");
                if (cols.length < 2) {
                    break;
                }
                string pid = cols[1];
                if (pid in added_pids) {
                    break;
                }
                app_list_widget.add_app (get_app_info_from_pid (pid));
                added_pids.add (pid);
            }
        }
    }

    private AppInfo? get_app_info_from_pid (string pid) {
        var path = FileUtils.read_link ("/proc/%s/exe".printf (pid));
        var parts = path.split ("/");
        string exec = parts[parts.length - 1];
        var all_apps = AppInfo.get_all ();
        foreach (var app in all_apps) {
            var exec_path = app.get_executable ();
            if (exec_path != null && exec in exec_path) {
                return app;
            }
        }
        return null;
    }
}
