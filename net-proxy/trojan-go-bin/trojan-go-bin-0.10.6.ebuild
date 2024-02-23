# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A Trojan proxy written in Go"
HOMEPAGE="https://github.com/p4gefau1t/trojan-go"
SRC_URI="
	amd64? ( https://github.com/p4gefau1t/trojan-go/releases/download/v${PV}/trojan-go-linux-amd64.zip )
	x86? ( https://github.com/p4gefau1t/trojan-go/releases/download/v${PV}/trojan-go-linux-386.zip )
	arm? ( https://github.com/p4gefau1t/trojan-go/releases/download/v${PV}/trojan-go-linux-arm.zip )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~arm"
RESTRICT="mirror"

RDEPEND="
	!net-proxy/trojan-go
"
BDEPEND="app-arch/unzip"

QA_PREBUILT="
	/usr/bin/trojan-go
"

S=${WORKDIR}

src_install() {
	dobin trojan-go

	insinto /usr/share/trojan-go
	doins *.dat

	insinto /etc/trojan-go
	doins example/*.json

	systemd_dounit example/*.service
}
