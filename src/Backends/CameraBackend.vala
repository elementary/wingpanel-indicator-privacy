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
    private const string BACKEND_NAME = _("Camera");

    private Widgets.AppList app_list_widget;
    private bool icon_visible = false;
    private string lsof_stdout;
    private Bamf.Matcher app_matcher;
    private Gee.HashMap<int, AppInfo> appinfo_by_pid;

    public Camera () {
        app_list_widget = new Widgets.AppList (BACKEND_NAME);
        appinfo_by_pid = new Gee.HashMap<int, AppInfo> ();
        app_matcher = Bamf.Matcher.get_default ();
    }

    public override Gtk.Widget get_app_list () {
        return app_list_widget;
    }

    public override void added () {
        Timeout.add (1000, () => {
            bool in_use = check_camera_in_use ();
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

    private void update_running_pids () {
        var pm = Services.ProcessMonitor.Monitor.get_default ();
        pm.update ();
        var applications = app_matcher.get_running_applications ();

        applications.@foreach ((app) => {
            var appinfo = new DesktopAppInfo.from_filename (app.get_desktop_file ());
            foreach (var window in app.get_windows ()) {
                var parent_pid = (int)window.get_pid ();
                appinfo_by_pid[parent_pid] = appinfo;
                var sub_processes = pm.get_sub_processes (parent_pid);
                foreach (int sp_pid in sub_processes) {
                    appinfo_by_pid[sp_pid] = appinfo;
                }
            }
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

    public void update_app_list () {
        update_running_pids ();

        app_list_widget.clear_apps ();
        Gee.ArrayList<string> added_pids = new Gee.ArrayList<string>();
        string[] lines = lsof_stdout.split ("\n");
        if (lines.length > 1) {
            for (int i = 1; i < lines.length; i++) {
                string[] cols = lines[i].split (" ");
                if (cols.length < 2) {
                    break;
                }
                string pid = "";
                for (int j = 1; j < cols.length; j++) {
                    if (cols[j] != "") {
                        pid = cols[j];
                        break;
                    }
                }
                if (pid in added_pids) {
                    break;
                }
                app_list_widget.add_app (get_app_info_from_pid (pid));
                added_pids.add (pid);
            }
        }
    }

    private AppInfo? get_app_info_from_pid (string pid) {
        var int_pid = int.parse (pid);
        if (appinfo_by_pid.has_key (int_pid)) {
            return appinfo_by_pid[int_pid];
        } else {
            return null;
        }
    }
}
