# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Utility library for the Abyss ecosystem"
HOMEPAGE="https://github.com/AbyssWM/Abyssutils"
ABYSS_COMMIT="b423270d43764d3b0f74584fa4a9c61ab1c9b9aa"
SRC_URI="https://github.com/AbyssWM/Abyssutils/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Abyssutils-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0/13"
KEYWORDS="~amd64"

DEPEND="
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
