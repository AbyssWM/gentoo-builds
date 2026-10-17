# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Native graphical toolkit and config preprocessor for Abyss"
HOMEPAGE="https://github.com/AbyssWM/Abysstoolkit"
ABYSS_COMMIT="9a095e013abdd600b617e912f207430eaeafda18"
SRC_URI="https://github.com/AbyssWM/Abysstoolkit/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Abysstoolkit-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0/6"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/abyssal-0.15.0:0=
	>=dev-libs/abyssgraphics-0.5.1:0=
	>=dev-libs/abyssparse-0.6.8:0=
	>=dev-libs/abyssutils-0.14.2:0=
	>=dev-libs/wayland-protocols-1.49
	dev-cpp/abseil-cpp
	dev-libs/iniparser
	dev-libs/wayland
	media-libs/libglvnd
	media-libs/mesa
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
"
RDEPEND="${DEPEND}
	dev-lang/python:3.14
"

BDEPEND="
	>=dev-util/abyss-scanner-0.4.5
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc LICENSE
}
