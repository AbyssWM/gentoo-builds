# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Polkit authentication agent for Abyss"
HOMEPAGE="https://github.com/AbyssWM/AbyssPolkit"
ABYSS_COMMIT="d9bc965683bb4b0b90d6039b22fbd39423a37c86"
SRC_URI="https://github.com/AbyssWM/AbyssPolkit/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/AbyssPolkit-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-cpp/sdbus-c++-2
	>=dev-libs/abyssgraphics-0.5.1:0=
	>=dev-libs/abyssparse-0.6.8:0=
	>=dev-libs/abysstoolkit-0.6.0:0=
	>=dev-libs/abyssutils-0.14.2:0=
	x11-libs/libdrm
	x11-libs/pixman
"
RDEPEND="${DEPEND}
	sys-auth/polkit
"

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
