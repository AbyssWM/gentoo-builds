# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Dynamic tiling Wayland compositor with C++ configuration"
HOMEPAGE="https://github.com/AbyssWM/Abyssland"
ABYSS_COMMIT="eafefb8907b6b6b46990977b56ec83dbcb019957"
SRC_URI="https://github.com/AbyssWM/Abyssland/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Abyssland-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/abyssal-0.15.0:0=
	>=dev-libs/abysscursor-0.1.13:0=
	>=dev-libs/abyssgraphics-0.5.1:0=
	>=dev-libs/abyssutils-0.14.2:0=
	>=dev-libs/abysswire-0.3.1:0=
	>=dev-libs/libinput-1.29
	>=dev-libs/wayland-protocols-1.49
	dev-cpp/muParser
	dev-libs/glib
	dev-libs/libei
	dev-libs/re2
	dev-libs/udis86
	dev-libs/wayland
	dev-util/glslang
	dev-util/spirv-tools
	media-libs/lcms
	media-libs/libglvnd
	media-libs/mesa
	sys-apps/util-linux
	sys-libs/readline
	x11-libs/cairo
	x11-libs/libXcursor
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	x11-libs/xcb-util-errors
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
"
RDEPEND="${DEPEND}
	sys-apps/dbus
	x11-base/xwayland
"

BDEPEND="
	>=dev-libs/abyssland-protocols-0.7.0
	>=dev-util/abyss-scanner-0.4.5
	dev-lang/python:3.14
	virtual/pkgconfig
"

SRC_URI+=" https://github.com/stephenberry/glaze/archive/refs/tags/v7.2.0.tar.gz -> glaze-7.2.0.tar.gz"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DABYSS_CONFIG="${S}/config.def.hpp"
		-DFETCHCONTENT_SOURCE_DIR_GLAZE="${WORKDIR}/glaze-7.2.0"
		-DNO_SYSTEMD=ON
		-DNO_UWSM=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc LICENSE
	newdoc "${WORKDIR}/glaze-7.2.0/LICENSE" glaze-LICENSE
	sed -e "s|^Name=.*|Name=Abyssland (D-Bus)|" -e "s|^Exec=.*|Exec=dbus-run-session /usr/bin/start-abyssland|" \
		"${ED}/usr/share/wayland-sessions/abyssland.desktop" \
		> "${ED}/usr/share/wayland-sessions/abyssland-dbus.desktop" || die
}
