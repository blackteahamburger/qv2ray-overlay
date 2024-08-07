# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Plugin for Qv2ray to support Trojan proxy in Qv2ray"
HOMEPAGE="https://github.com/Qv2ray/QvPlugin-Trojan"
EGIT_REPO_URI="${HOMEPAGE}.git"
EGIT_COMMIT="v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="qt6 +tcpfastopen nat reuseport"

DEPEND="
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	qt6? ( dev-qt/qtbase:6[gui,network,widgets] )
	dev-libs/boost:=
	dev-libs/openssl:0=
"
RDEPEND="
	>=net-proxy/qv2ray-2.7.0[qt6=]
	${DEPEND}
"

src_configure() {
	local mycmakeargs=(
		-DQVPLUGIN_USE_QT6=$(usex qt6)
		-DFORCE_TCP_FASTOPEN=$(usex tcpfastopen)
		-DENABLE_NAT=$(usex nat)
		-DENABLE_REUSE_PORT=$(usex reuseport)
	)
	cmake_src_configure
}

src_install(){
	insinto "/usr/share/qv2ray/plugins"
	insopts -m755
	doins "${BUILD_DIR}/libQvPlugin-Trojan.so"
}
