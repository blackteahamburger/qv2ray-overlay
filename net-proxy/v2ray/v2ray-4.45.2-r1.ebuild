# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GO_OPTIONAL=1

inherit systemd go-module

DESCRIPTION="A platform for building proxies to bypass network restrictions."
HOMEPAGE="https://www.v2fly.org/"
SRC_URI="
	https://github.com/blackteahamburger/v2ray-core/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/blackteahamburger/gentoo-go-deps/releases/download/${P}/${P}-vendor.tar.xz
"

S="${WORKDIR}/${PN}-core-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+tool"

RESTRICT="mirror"

DEPEND="
	app-alternatives/v2ray-geoip
	app-alternatives/v2ray-geosite
"
RDEPEND="
	!net-proxy/v2ray-bin
	${DEPEND}
"
BDEPEND="<dev-lang/go-1.20"

src_unpack() {
	go-module_src_unpack
}

src_prepare() {
	sed -i 's|/usr/local/bin|/usr/bin|;s|/usr/local/etc|/etc|' release/config/systemd/system/*.service || die
	sed -i '/^User=/s/nobody/v2ray/;/^User=/aDynamicUser=true' release/config/systemd/system/*.service || die
	default
}

src_compile() {
	ego build -o v2ray -trimpath -ldflags "-s -w -buildid=" ./main
	if use tool; then
		ego build -o v2ctl -trimpath -ldflags "-s -w" -tags confonly ./infra/control/main
	fi
}

src_install() {
	dobin v2ray
	if use tool; then
		dobin v2ctl
	fi

	insinto /etc/v2ray
	newins release/config/config.json config.json.example

	newinitd "${FILESDIR}/v2ray.initd" v2ray
	systemd_dounit release/config/systemd/system/v2ray{,@}.service
}
