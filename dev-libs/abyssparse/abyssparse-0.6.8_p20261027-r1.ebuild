# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Configuration parsing library for Abyss"
HOMEPAGE="https://github.com/AbyssWM/Abyssparse"
ABYSS_COMMIT="6c3c77e8a029e46d7416b84f67aff833f9beedd2"
SRC_URI="https://github.com/AbyssWM/Abyssparse/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Abyssparse-${ABYSS_COMMIT}"

LICENSE="LGPL-3"
SLOT="0/2"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/abyssutils-0.14.2:0=
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
	dodoc COPYING COPYRIGHT
}
