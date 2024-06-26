# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Utility to control your cd/dvd drive"
HOMEPAGE="https://cdctl.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/cdctl/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

PATCHES=( "${FILESDIR}"/${PN}-0.16-Makefile.in.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC
	default
}
