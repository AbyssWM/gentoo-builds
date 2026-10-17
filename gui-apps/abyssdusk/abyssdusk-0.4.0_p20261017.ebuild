# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Display color temperature manager for Abyss"
HOMEPAGE="https://github.com/AbyssWM/AbyssDusk"
ABYSS_COMMIT="01ad76f953f8d5139b5e03cd7cfaaf9342667f0b"
SRC_URI="https://github.com/AbyssWM/AbyssDusk/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/AbyssDusk-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/abyssparse-0.6.8:0=
	>=dev-libs/abyssutils-0.14.2:0=
	>=dev-libs/wayland-protocols-1.49
	dev-libs/wayland
"
RDEPEND="${DEPEND}"

BDEPEND="
	>=dev-libs/abyssland-protocols-0.7.0
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
