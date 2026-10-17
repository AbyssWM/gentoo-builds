# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Dialogs and application tools for Abyss"
HOMEPAGE="https://github.com/AbyssWM/Abyss-guiutils"
ABYSS_COMMIT="da6646906dab8557440ed8f5cca4157452105fc2"
SRC_URI="https://github.com/AbyssWM/Abyss-guiutils/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Abyss-guiutils-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/abyssparse-0.6.8:0=
	>=dev-libs/abysstoolkit-0.6.0:0=
	>=dev-libs/abyssutils-0.14.2:0=
	x11-libs/libdrm
	x11-libs/libxkbcommon
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
