# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Plugin for Qv2ray to support SIP003 in Qv2ray"
HOMEPAGE="https://github.com/Qv2ray/QvPlugin-SS"
EGIT_REPO_URI="${HOMEPAGE}.git"
EGIT_COMMIT="v${PV}"

LICENSE="GPL-3"
SLOT="0"
IUSE="qt6 +system-libuv +system-libsodium +system-mbedtls"

DEPEND="
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	qt6? ( dev-qt/qtbase:6[gui,network,widgets] )
	system-libuv? ( dev-libs/libuv:= )
	system-libsodium? ( dev-libs/libsodium:= )
	system-mbedtls? ( net-libs/mbedtls:= )
	dev-libs/openssl:0=
"
RDEPEND="
	>=net-proxy/qv2ray-2.7.0[qt6?]
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}/minsigstksz.patch"
)

pkg_setup() {
	EGIT_SUBMODULES=( '*' )

	if use system-libuv; then
		EGIT_SUBMODULES+=( '-*/libuv' )
	fi

	if use system-libsodium; then
		EGIT_SUBMODULES+=( '-*/libsodium' )
	fi

	if use system-mbedtls; then
		EGIT_SUBMODULES+=( '-*/mbedtls' )
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE
		-DCMAKE_INSTALL_RPATH="\$ORIGIN"
		-DQVPLUGIN_USE_QT6=$(usex qt6)
		-DSSR_UVW_WITH_QT=1
		-DUSE_SYSTEM_LIBUV=$(usex system-libuv)
		-DUSE_SYSTEM_SODIUM=$(usex system-libsodium)
		-DUSE_SYSTEM_MBEDTLS=$(usex system-mbedtls)
		-DSTATIC_LINK_LIBUV=$(usex !system-libuv)
		-DSTATIC_LINK_SODIUM=$(usex !system-libsodium)
	)
	cmake_src_configure
}

src_install(){
	insinto "/usr/share/qv2ray/plugins"
	insopts -m755
	doins "${BUILD_DIR}/libQvPlugin-SS.so"
}
