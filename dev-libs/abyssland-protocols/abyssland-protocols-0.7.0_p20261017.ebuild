# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit meson

DESCRIPTION="Wayland protocol extensions for Abyss"
HOMEPAGE="https://github.com/AbyssWM/Abyssland-protocols"
ABYSS_COMMIT="23246e7462e75bc07a04e62b1edc68b68770f73e"
SRC_URI="https://github.com/AbyssWM/Abyssland-protocols/archive/${ABYSS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Abyssland-protocols-${ABYSS_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	virtual/pkgconfig
"

src_install() {
	meson_src_install
	dodoc LICENSE
}
