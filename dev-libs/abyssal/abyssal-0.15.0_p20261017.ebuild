# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Rendering and display backend library for Abyss"
HOMEPAGE="https://github.com/AbyssWM/Abyssal"
ABYSS_COMMIT="95bbf980b4c704b517d557038ba4460080847314"
SRC_URI="https://github.com/AbyssWM/Abyssal/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Abyssal-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0/14"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/abyssutils-0.14.2:0=
	>=dev-libs/libinput-1.29
	>=dev-libs/wayland-protocols-1.49
	dev-libs/wayland
	media-libs/libdisplay-info
	media-libs/libglvnd
	media-libs/mesa
	sys-apps/hwdata
	sys-auth/seatd
	virtual/libudev
	x11-libs/libdrm
	x11-libs/pixman
"
RDEPEND="${DEPEND}"

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
