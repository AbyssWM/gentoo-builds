# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Cursor library and theme tools for Abyss"
HOMEPAGE="https://github.com/AbyssWM/Abysscursor"
ABYSS_COMMIT="6a762edb75677f8cc46a20cb26b615bbabb5155a"
SRC_URI="https://github.com/AbyssWM/Abysscursor/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Abysscursor-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0/0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/abyssparse-0.6.8:0=
	dev-cpp/tomlplusplus
	dev-libs/libzip
	gnome-base/librsvg
	x11-libs/cairo
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
