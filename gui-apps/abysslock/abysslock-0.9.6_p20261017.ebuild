# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit cmake

DESCRIPTION="Wayland session lock for Abyss"
HOMEPAGE="https://github.com/AbyssWM/AbyssLock"
ABYSS_COMMIT="651a5ecf43b742965bca25e99056cf8e7cf83aa3"
SRC_URI="https://github.com/AbyssWM/AbyssLock/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/AbyssLock-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-cpp/sdbus-c++-2
	>=dev-libs/abyssgraphics-0.5.1:0=
	>=dev-libs/abyssparse-0.6.8:0=
	>=dev-libs/abyssutils-0.14.2:0=
	>=dev-libs/wayland-protocols-1.49
	dev-libs/wayland
	media-libs/libglvnd
	media-libs/mesa
	sys-libs/pam
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
"
RDEPEND="${DEPEND}"

BDEPEND="
	>=dev-util/abyss-scanner-0.4.5
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/0001-install-pam-in-sysconfdir.patch"
)

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
