# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Wayland color picker for Abyss"
HOMEPAGE="https://github.com/AbyssWM/AbyssPicker"
ABYSS_COMMIT="97240042de866686f1da1db3847ddd5f37603e27"
SRC_URI="https://github.com/AbyssWM/AbyssPicker/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/AbyssPicker-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/abyssutils-0.14.2:0=
	>=dev-libs/wayland-protocols-1.49
	dev-libs/wayland
	media-libs/libjpeg-turbo
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
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
