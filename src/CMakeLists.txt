find_package (PkgConfig)

# Add all your dependencies to the list below
pkg_check_modules (DEPS REQUIRED gthread-2.0 gtk+-3.0 wingpanel-2.0 libbamf3 libgtop-2.0 gio-unix-2.0)

add_definitions (${DEPS_CFLAGS})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.22.0" MINIMUM)

include (ValaPrecompile)
# Add all your vala files and requires packages to the List below to include them in the build
vala_precompile (VALA_C ${CMAKE_PROJECT_NAME}
  Indicator.vala
  Widgets/AppList.vala
  Widgets/AppListRow.vala
  Widgets/DisplayWidget.vala
  Backends/AbstractBackend.vala
  Backends/LocationBackend.vala
  Backends/CameraBackend.vala
  Services/DbusInterfaces.vala
  Services/ProcessMonitor/Monitor.vala
  Services/ProcessMonitor/Process.vala
  ${CMAKE_CURRENT_BINARY_DIR}/config.vala
PACKAGES
  gtk+-3.0
  wingpanel-2.0
  libbamf3
  gio-unix-2.0
  posix
OPTIONS
  --thread
CUSTOM_VAPIS
  ../vapi/libgtop-2.0.vapi
)

add_library (${CMAKE_PROJECT_NAME} MODULE ${VALA_C})
target_link_libraries(${CMAKE_PROJECT_NAME} ${DEPS_LIBRARIES})

# Installation
install (TARGETS ${CMAKE_PROJECT_NAME} DESTINATION ${PKGDATADIR})
