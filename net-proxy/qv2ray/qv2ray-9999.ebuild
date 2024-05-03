# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg git-r3 flag-o-matic

DESCRIPTION="Qt GUI fontend of v2ray"
HOMEPAGE="https://github.com/Qv2ray/Qv2ray"
EGIT_REPO_URI="${HOMEPAGE}.git"

if [[ ${PV} != 9999 ]]; then
	EGIT_COMMIT="86a078226816595f69821d9819ee527a4f0e598d"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="qt6 +system-libuv test +themes v4-core"
RESTRICT="!test? ( test )"

DEPEND="
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
# dev-libs/v2ray-rules-dat is not allowed as an alternative implementation of app-alternatives/v2ray-geo{ip,site}
# when using V2ray v5 core
# https://github.com/Qv2ray/Qv2ray/issues/1717
RDEPEND="
	!v4-core? (
			|| (
				=net-proxy/v2ray-bin-5*
				=net-proxy/v2ray-5*
			)
			!app-alternatives/v2ray-geoip[loyalsoldier]
			!app-alternatives/v2ray-geosite[loyalsoldier]
		)
	v4-core? (
			|| (
				=net-proxy/v2ray-bin-4*
				=net-proxy/v2ray-4*
				net-proxy/Xray
			)
		)
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
		-DQV2RAY_DISABLE_AUTO_UPDATE=ON
		-DQV2RAY_HAS_BUILTIN_THEMES=$(usex themes)
		-DQV2RAY_QT6=$(usex qt6)
		-DQV2RAY_USE_V5_CORE=$(usex !v4-core)
		-DUSE_SYSTEM_LIBUV=$(usex system-libuv)
	)
	cmake_src_configure
}
