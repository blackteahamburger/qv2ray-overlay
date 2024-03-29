# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg git-r3 flag-o-matic

DESCRIPTION="Qt GUI fontend of v2ray"
HOMEPAGE="https://github.com/Qv2ray/Qv2ray"
EGIT_REPO_URI="${HOMEPAGE}.git"

if [[ ${PV} != 9999 ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="qml-ui qt6 +system-libuv test +themes"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	qml-ui? ( qt6 )
"

DEPEND="
	qml-ui? ( dev-qt/qtdeclarative:6 )
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
	qt6? (
		dev-qt/qtbase:6[gui,network,widgets]
		dev-qt/qtsvg:6
	)
	system-libuv? ( dev-libs/libuv:= )
	net-libs/grpc:=
	dev-libs/protobuf:=
	net-misc/curl
"
if [[ ${PV} == 9999 ]]; then
	# dev-libs/v2ray-rules-dat is not allowed as an alternative implementation of app-alternatives/v2ray-geo{ip,site}
	# https://github.com/Qv2ray/Qv2ray/issues/1717
	RDEPEND="
		|| ( =net-proxy/v2ray-bin-5* =net-proxy/v2ray-5* )
		!app-alternatives/v2ray-geoip[loyalsoldier]
		!app-alternatives/v2ray-geosite[loyalsoldier]
	"
else
	RDEPEND="
		|| ( =net-proxy/v2ray-bin-4* =net-proxy/v2ray-4* )
	"
fi
RDEPEND="
	${RDEPEND}
	dev-libs/openssl:0=
	${DEPEND}
"
BDEPEND="
	!qt6? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
"

pkg_setup() {
	if use system-libuv; then
		EGIT_SUBMODULES=( '*' '-*/libuv' )
	fi
}

src_prepare() {
	cmake_src_prepare
	xdg_environment_reset
}

src_configure() {
	# https://github.com/Qv2ray/Qv2ray/issues/1734
	filter-lto

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DQV2RAY_DEFAULT_VASSETS_PATH="/usr/share/v2ray"
		-DQV2RAY_DEFAULT_VCORE_PATH="/usr/bin/v2ray"
		-DQV2RAY_DISABLE_AUTO_UPDATE=ON
		-DQV2RAY_HAS_BUILTIN_THEMES=$(usex themes)
		-DQV2RAY_UI_TYPE=$(usex qml-ui QML QWidget)
		-DQV2RAY_QT6=$(usex qt6)
		-DUSE_SYSTEM_LIBUV=$(usex system-libuv)
	)
	cmake_src_configure
}
