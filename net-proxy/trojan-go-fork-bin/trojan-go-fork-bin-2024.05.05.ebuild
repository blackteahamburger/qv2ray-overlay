# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A fork of trojan-go"
HOMEPAGE="https://github.com/Potterli20/trojan-go-fork"
DIST_URI="https://github.com/Potterli20/trojan-go-fork/releases/download/V${PV}/trojan-go-fork-linux"
BASE_NAME="trojan-go-fork-${PV}-linux"
SRC_URI="
	amd64? (
		x86-64-v1? ( ${DIST_URI}-amd64.zip -> ${BASE_NAME}-amd64.zip )
		x86-64-v2? ( ${DIST_URI}-amd64-v2.zip -> ${BASE_NAME}-amd64-v2.zip )
		x86-64-v3? ( ${DIST_URI}-amd64-v3.zip -> ${BASE_NAME}-amd64-v3.zip )
		x86-64-v4? ( ${DIST_URI}-amd64-v4.zip -> ${BASE_NAME}-amd64-v4.zip )
	)
	loong? ( ${DIST_URI}-loong64.zip -> ${BASE_NAME}-loong64.zip )
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
	ppc64? (
		big-endian? ( ${DIST_URI}-ppc64.zip -> ${BASE_NAME}-ppc64.zip )
		!big-endian? ( ${DIST_URI}-ppc64le.zip -> ${BASE_NAME}-ppc64le.zip )
	)
	riscv? ( ${DIST_URI}-riscv64.zip -> ${BASE_NAME}-riscv64.zip )
	s390? ( ${DIST_URI}-s390x.zip -> ${BASE_NAME}-s390x.zip )
	x86? (
		cpu_flags_x86_sse2? ( ${DIST_URI}-386-sse2.zip -> ${BASE_NAME}-386-sse2.zip )
		!cpu_flags_x86_sse2? ( ${DIST_URI}-386-softfloat.zip -> ${BASE_NAME}-386-softfloat.zip )
	)
"

S=${WORKDIR}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~loong ~mips ~ppc64 ~riscv ~s390 ~x86"
IUSE="abi_mips_n64 abi_mips_o32 abi_s390_64 +x86-64-v1 x86-64-v2 x86-64-v3 x86-64-v4 big-endian cpu_flags_x86_sse2 softfloat"
REQUIRED_USE="
	amd64? ( ^^ ( x86-64-v1 x86-64-v2 x86-64-v3 x86-64-v4 ) )
	mips? ( || ( abi_mips_n64 abi_mips_o32 ) )
	s390? ( abi_s390_64 )
	x86? ( !cpu_flags_x86_sse2? ( softfloat ) )
"
RESTRICT="mirror"

DEPEND="|| ( app-alternatives/v2ray-geoip app-alternatives/v2ray-geosite )"
RDEPEND="
	!net-proxy/trojan-go
	!net-proxy/trojan-go-bin
	!net-proxy/trojan-go-fork
	${DEPEND}
"
BDEPEND="app-arch/unzip"

QA_PREBUILT="
	/usr/bin/trojan-go-fork
"

src_install() {
	dobin trojan-go-fork
	dosym -r /usr/bin/trojan-go-fork /usr/bin/trojan-go

	dosym -r /usr/share/v2ray/geosite.dat /usr/share/trojan-go/geosite.dat
	dosym -r /usr/share/v2ray/geoip.dat /usr/share/trojan-go/geoip.dat

	insinto /etc/trojan-go
	doins example/*.json

	systemd_dounit example/*.service
}
