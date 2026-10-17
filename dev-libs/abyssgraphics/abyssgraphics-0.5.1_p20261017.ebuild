# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Graphics and resource library for Abyss"
HOMEPAGE="https://github.com/AbyssWM/Abyssgraphics"
ABYSS_COMMIT="22ddc7596eefffcee611181a556ff1a753eaf433"
SRC_URI="https://github.com/AbyssWM/Abyssgraphics/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Abyssgraphics-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0/4"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/abyssutils-0.14.2:0=
	gnome-base/librsvg
	media-libs/libglvnd
	media-libs/libheif
	media-libs/libjpeg-turbo
	media-libs/libjxl
	media-libs/libpng
	media-libs/libwebp
	media-libs/mesa
	sys-apps/file
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/pango
	x11-libs/pixman
"
RDEPEND="${DEPEND}"

BDEPEND="
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
