# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Plugin for Qv2ray to run any commands when something happens in Qv2ray"
HOMEPAGE="https://github.com/Qv2ray/QvPlugin-Command"
EGIT_REPO_URI="${HOMEPAGE}.git"

if [[ ${PV} != 9999 ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="qt6"

DEPEND="
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
"
RDEPEND="
	>=net-proxy/qv2ray-2.7.0[qt6?]
	${DEPEND}
"

src_configure() {
	local mycmakeargs=(
		-DQVPLUGIN_USE_QT6=$(usex qt6)
	)
	cmake_src_configure
}

src_install(){
	insinto "/usr/share/qv2ray/plugins"
	insopts -m755
	doins "${BUILD_DIR}/libQvPlugin-Command.so"
}
