# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Plugin for Qv2ray to support SSR in Qv2ray"
HOMEPAGE="https://github.com/Qv2ray/QvPlugin-SSR"
GIT_COMMIT_QVPLUGIN_INTERFACE="911c4adbb7b598435162da245ab248d215d3f018"
GIT_COMMIT_SHADOWSOCKSR_UVW="b303c4c463fed3e6b963f93b73d8003dd5debf5c"
QVPLUGIN_INTERFACE_PV="0_pre20210214"
SHADOWSOCKSR_UVW_PV="0_pre20210412"
SRC_URI="
	https://github.com/Qv2ray/QvPlugin-SSR/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Qv2ray/QvPlugin-Interface/archive/${GIT_COMMIT_QVPLUGIN_INTERFACE}.tar.gz
		-> QvPlugin-Interface-${QVPLUGIN_INTERFACE_PV}.tar.gz
	https://github.com/Qv2ray/shadowsocksr-uvw/archive/${GIT_COMMIT_SHADOWSOCKSR_UVW}.tar.gz
		-> shadowsocksr-uvw-${SHADOWSOCKSR_UVW_PV}.tar.gz
"

S="${WORKDIR}/QvPlugin-SSR-${PV}"

LICENSE="GPL-3"
SLOT="0"
IUSE="qt6"

DEPEND="
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	qt6? ( dev-qt/qtbase:6[gui,network,widgets] )
	dev-libs/libuv:=
	dev-libs/libsodium:=
	dev-libs/openssl:0=
"
RDEPEND="
	>=net-proxy/qv2ray-2.7.0[qt6=]
	${DEPEND}
"

src_unpack() {
	default
	rmdir "${S}/interface" || die
	mv "${WORKDIR}/QvPlugin-Interface-${GIT_COMMIT_QVPLUGIN_INTERFACE}" "${S}/interface" || die
	rmdir "${S}/3rdparty/shadowsocksr-uvw" ||die
	mv "${WORKDIR}/shadowsocksr-uvw-${GIT_COMMIT_SHADOWSOCKSR_UVW}" "${S}/3rdparty/shadowsocksr-uvw" || die
}

src_configure() {
	local mycmakeargs=(
		-DQVPLUGIN_USE_QT6=$(usex qt6)
		-DSSR_UVW_WITH_QT=1
		-DUSE_SYSTEM_LIBUV=ON
		-DUSE_SYSTEM_SODIUM=ON
		-DSTATIC_LINK_LIBUV=OFF
		-DSTATIC_LINK_SODIUM=OFF
	)
	cmake_src_configure
}

src_install(){
	insinto "/usr/share/qv2ray/plugins"
	insopts -m755
	doins "${BUILD_DIR}/libQvPlugin-SSR.so"
}
