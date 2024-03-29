# Wingpanel Privacy Indicator
[![Translation status](https://l10n.elementary.io/widgets/wingpanel/-/wingpanel-indicator-privacy/svg-badge.svg)](https://l10n.elementary.io/engage/wingpanel/?utm_source=widget)

![Screenshot](data/screenshot.png)

The Privacy indicator watches for usage of the camera or location services and displays a tattle-taling camera and/or location icon in the panel when they are being used. For camera usage, the indicator popover lists the app(s) using the camera.

## Building and Installation

You'll need the following dependencies:

* libbamf3-dev
* libgee-0.8-dev
* libgranite-dev
* libgtk-3-dev
* libgtop2-dev
* libwingpanel-dev
* meson
* valac

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`

    ninja install
