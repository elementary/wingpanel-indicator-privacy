# Wingpanel Privacy Indicator
[![l10n](https://l10n.elementary.io/widgets/wingpanel/wingpanel-indicator-privacy/svg-badge.svg)](https://l10n.elementary.io/projects/wingpanel/wingpanel-indicator-privacy)

**N.B:** This is still work in progress and not all features are working/complete yet.

## Building and Installation

You'll need the following dependencies:

* cmake
* libgtk-3-dev
* libwingpanel-2.0-dev
* valac

It's recommended to create a clean build environment

    mkdir build
    cd build/
    
Run `cmake` to configure the build environment and then `make` to build

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make
    
To install, use `make install`

    sudo make install
