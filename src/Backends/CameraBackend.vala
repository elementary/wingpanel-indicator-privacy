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

    public Camera () {
        app_list_widget = new Widgets.AppList (BACKEND_NAME);
    }

    public override Gtk.Widget get_app_list () {
        return app_list_widget;
    }

    public override void added () {
        Timeout.add (1000, () => {
            bool in_use = check_camera_in_use ();
            if (in_use) {
                update_app_list ();
            }
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
        var all_apps = AppInfo.get_all ();
        // Check to see if we can get an exact explicit path match
        foreach (var app in all_apps) {
            var exec_path = app.get_executable ();
            if (exec_path != null) {
                if (!exec_path.has_prefix ("/")) {
                    exec_path = get_full_exec_path (exec_path);
                }
                if (exec_path.has_prefix (path)) {
                    return app;
                }
            }
        }
        // If explicit path fails, try and find an executable with same name
        foreach (var app in all_apps) {
            var exec_path = app.get_executable ().split ("/");
            if (exec_path != null) {
                var exec = exec_path[exec_path.length - 1].split (" ")[0];
                var pid_name_parts = path.split ("/");
                var pid_name = pid_name_parts[pid_name_parts.length - 1];
                if (exec == pid_name) {
                    return app;
                }
            }
        }
        return null;
    }

    // This is the equivalent of the 'which' helper built into UNIX shells.
    private string get_full_exec_path (string exec) {
        var env_path = Environ.get_variable (Environ.@get (), "PATH");
        var paths = env_path.split (":");
        foreach (var path in paths) {
            var possible_exec = Path.build_path (Path.DIR_SEPARATOR_S, path, exec);
            var is_exec = FileUtils.test (possible_exec, FileTest.IS_EXECUTABLE);
	        if (is_exec) {
                return possible_exec;
            }
        }
        return "";
    }
}
