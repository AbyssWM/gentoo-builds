# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Wallpaper manager for Abyss"
HOMEPAGE="https://github.com/AbyssWM/AbyssPaper"
ABYSS_COMMIT="4e06e7590cd135fc7592e60b469699a641bec47c"
SRC_URI="https://github.com/AbyssWM/AbyssPaper/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/AbyssPaper-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/abyssparse-0.6.8:0=
	>=dev-libs/abysstoolkit-0.6.0:0=
	>=dev-libs/abyssutils-0.14.2:0=
	>=dev-libs/abysswire-0.3.1:0=
	dev-libs/wayland
	media-libs/libglvnd
	media-libs/mesa
	media-video/mpv[libmpv]
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
		-DABYSS_CONFIG_DIR="${WORKDIR}/empty-config"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc LICENSE
}
