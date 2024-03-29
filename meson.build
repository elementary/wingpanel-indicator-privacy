project('privacy', 'vala', 'c')

gettext_name = meson.project_name() + '-indicator'
i18n = import('i18n')

prefix = get_option('prefix')
libdir = join_paths(prefix, get_option('libdir'))

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(gettext_name), language:'c')

add_project_arguments(
    '--vapidir', join_paths(meson.current_source_dir(), 'vapi'),
    language: 'vala'
)

add_project_arguments('-DG_LOG_DOMAIN="io.elementary.wingpanel.privacy"', language:'c')

wingpanel_dep = dependency('wingpanel')
wingpanel_indicatorsdir = wingpanel_dep.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', libdir])

config_data = configuration_data()
config_data.set_quoted('LOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name() + '-indicator')
config_file = configure_file(
    input: 'src/Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

shared_module(
    meson.project_name(),
    config_file,
    'src/Indicator.vala',
    'src/Widgets/AppList.vala',
    'src/Widgets/AppListRow.vala',
    'src/Widgets/DisplayWidget.vala',
    'src/Backends/AbstractBackend.vala',
    'src/Backends/CameraBackend.vala',
    'src/Backends/LocationBackend.vala',
    'src/Services/DbusInterfaces.vala',
    'src/Services/ProcessMonitor/Monitor.vala',
    'src/Services/ProcessMonitor/Process.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('gtk+-3.0'),
        dependency('granite'),
        dependency('libbamf3'),
        dependency('libgtop-2.0'),
        dependency('gio-unix-2.0'),
        meson.get_compiler('vala').find_library('posix'),
        wingpanel_dep
    ],
    install: true,
    install_dir : wingpanel_indicatorsdir,
)

subdir('data')
subdir('po')
