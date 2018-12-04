# Wingpanel Privacy Indicator
[![l10n](https://l10n.elementary.io/widgets/wingpanel/wingpanel-indicator-privacy/svg-badge.svg)](https://l10n.elementary.io/projects/wingpanel/wingpanel-indicator-privacy)

The Privacy indicator watches for usage of the camera or location services and displays a tattle-taling camera and/or location icon in the panel when they are being used. For camera usage, the indicator popover lists the app(s) using the camera.

## Building and Installation

You'll need the following dependencies:

* meson
* libgee-0.8-dev
* libgtk-3-dev
* libwingpanel-2.0-dev
* valac
* libbamf3-dev
* libgtop2-dev

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`

    sudo ninja install
