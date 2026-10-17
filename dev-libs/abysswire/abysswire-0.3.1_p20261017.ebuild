# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="IPC wire protocol library and scanner for Abyss"
HOMEPAGE="https://github.com/AbyssWM/Abysswire"
ABYSS_COMMIT="55565230b6ac2fbdf9fbeb23f074d4c006715d69"
SRC_URI="https://github.com/AbyssWM/Abysswire/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Abysswire-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0/3"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/abyssutils-0.14.2:0=
	dev-libs/libffi
	dev-libs/pugixml
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
