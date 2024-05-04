# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A Trojan proxy written in Go"
HOMEPAGE="https://github.com/p4gefau1t/trojan-go"
DIST_URI="https://github.com/p4gefau1t/trojan-go/releases/download/v${PV}/trojan-go-linux"
BASE_NAME="trojan-go-${PV}-linux"
SRC_URI="
	amd64? ( ${DIST_URI}-amd64.zip -> ${BASE_NAME}-amd64.zip )
	arm? (
		cpu_flags_arm_v5? ( ${DIST_URI}-armv5.zip -> ${BASE_NAME}-armv5.zip )
		cpu_flags_arm_v6? ( ${DIST_URI}-armv6.zip -> ${BASE_NAME}-armv6.zip )
		cpu_flags_arm_v7? ( ${DIST_URI}-armv7.zip -> ${BASE_NAME}-armv7.zip )
		cpu_flags_arm_v8? ( ${DIST_URI}-armv8.zip -> ${BASE_NAME}-armv8.zip )
		!cpu_flags_arm_v5? (
		!cpu_flags_arm_v6? (
		!cpu_flags_arm_v7? (
		!cpu_flags_arm_v8? (
			${DIST_URI}-arm.zip -> ${BASE_NAME}-arm.zip
		) ) ) )
	)
	mips? (
		abi_mips_o32? (
			big-endian? (
				softfloat? ( ${DIST_URI}-mips-softfloat.zip -> ${BASE_NAME}-mips-softfloat.zip )
				!softfloat? ( ${DIST_URI}-mips-hardfloat.zip -> ${BASE_NAME}-mips-hardfloat.zip )
			)
			!big-endian? (
				softfloat? ( ${DIST_URI}-mipsle-softfloat.zip -> ${BASE_NAME}-mipsle-softfloat.zip )
				!softfloat? ( ${DIST_URI}-mipsle-hardfloat.zip -> ${BASE_NAME}-mipsle-hardfloat.zip )
			)
		)
		abi_mips_n64? (
			big-endian? ( ${DIST_URI}-mips64.zip -> ${BASE_NAME}-mips64.zip )
			!big-endian? ( ${DIST_URI}-mips64le.zip -> ${BASE_NAME}-mips64le.zip )
		)
	)
	x86? ( ${DIST_URI}-386.zip -> ${BASE_NAME}-386.zip )
"

S=${WORKDIR}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~mips ~x86"
IUSE="abi_mips_n64 abi_mips_o32 big-endian cpu_flags_arm_v5 cpu_flags_arm_v7 cpu_flags_arm_v6 cpu_flags_arm_v8 softfloat"
REQUIRED_USE="mips? ( || ( abi_mips_n64 abi_mips_o32 ) )"
RESTRICT="mirror"

DEPEND="|| ( app-alternatives/v2ray-geoip app-alternatives/v2ray-geosite )"
RDEPEND="
	!net-proxy/trojan-go
	!net-proxy/trojan-go-fork
	!net-proxy/trojan-go-fork-bin
	${DEPEND}
"
BDEPEND="app-arch/unzip"

QA_PREBUILT="
	/usr/bin/trojan-go
"

src_install() {
	dobin trojan-go

	dosym -r /usr/share/v2ray/geosite.dat /usr/share/trojan-go/geosite.dat
	dosym -r /usr/share/v2ray/geoip.dat /usr/share/trojan-go/geoip.dat

	insinto /etc/trojan-go
	doins example/*.json

	systemd_dounit example/*.service
}
