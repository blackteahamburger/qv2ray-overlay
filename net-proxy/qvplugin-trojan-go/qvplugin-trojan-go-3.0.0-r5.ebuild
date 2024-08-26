# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Plugin for Qv2ray to support Trojan-Go proxy in Qv2ray"
HOMEPAGE="https://github.com/Qv2ray/QvPlugin-Trojan-Go"
GIT_COMMIT_QVPLUGIN_INTERFACE="911c4adbb7b598435162da245ab248d215d3f018"
GIT_COMMIT_QJSONSTRUCT="02416895f2f1fb826f8e9207d8bbe5804b6d0441"
QVPLUGIN_INTERFACE_PV="0_pre20210214"
QJSONSTRUCT_PV="0_pre20210305"
SRC_URI="
	https://github.com/Qv2ray/QvPlugin-Trojan-Go/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Qv2ray/QvPlugin-Interface/archive/${GIT_COMMIT_QVPLUGIN_INTERFACE}.tar.gz
		-> QvPlugin-Interface-${QVPLUGIN_INTERFACE_PV}.tar.gz
	https://github.com/Qv2ray/QJsonStruct/archive/${GIT_COMMIT_QJSONSTRUCT}.tar.gz
		-> QJsonStruct-${QJSONSTRUCT_PV}.tar.gz
"

S="${WORKDIR}/QvPlugin-Trojan-Go-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="qt6"

DEPEND="
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	qt6? ( dev-qt/qtbase:6[gui,network,widgets] )
"
RDEPEND="
	>=net-proxy/qv2ray-2.7.0[qt6=]
	net-proxy/trojan-go-fork
	${DEPEND}
"

src_unpack() {
	default
	rmdir "${S}/interface" || die
	mv "${WORKDIR}/QvPlugin-Interface-${GIT_COMMIT_QVPLUGIN_INTERFACE}" "${S}/interface" || die
	rmdir "${S}/libs/QJsonStruct" || die
	mv "${WORKDIR}/QJsonStruct-${GIT_COMMIT_QJSONSTRUCT}" "${S}/libs/QJsonStruct" || die
}

src_configure() {
	local mycmakeargs=(
		-DQVPLUGIN_USE_QT6=$(usex qt6)
	)
	cmake_src_configure
}

src_install(){
	insinto "/usr/share/qv2ray/plugins"
	insopts -m755
	doins "${BUILD_DIR}/libQvPlugin-TrojanGo.so"
}
