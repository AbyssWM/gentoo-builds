# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Desktop portal and screen sharing picker for Abyss"
HOMEPAGE="https://github.com/AbyssWM/Xdg-desktop-portal-abyss"
ABYSS_COMMIT="c4e1197e9aaed10773d0d142d13d40223a92b0eb"
SRC_URI="https://github.com/AbyssWM/Xdg-desktop-portal-abyss/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Xdg-desktop-portal-abyss-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-cpp/sdbus-c++-2
	>=dev-libs/abyssparse-0.6.8:0=
	>=dev-libs/abyssutils-0.14.2:0=
	>=dev-libs/wayland-protocols-1.49
	>=media-video/pipewire-1.1.82
	dev-libs/wayland
	dev-qt/qtbase:6[widgets]
	media-libs/mesa
	sys-apps/util-linux
	x11-libs/libdrm
"
RDEPEND="${DEPEND}
	sys-apps/xdg-desktop-portal
"

BDEPEND="
	>=dev-libs/abyssland-protocols-0.7.0
	>=dev-util/abyss-scanner-0.4.5
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DSYSTEMD_SERVICES=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc LICENSE
}
