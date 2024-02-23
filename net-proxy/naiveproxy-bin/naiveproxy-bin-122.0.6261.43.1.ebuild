# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_rs 4 -)

DESCRIPTION="NaiveProxy uses Chromium's network stack to camouflage traffic with strong censorship resistence and low detectablility"
HOMEPAGE="https://github.com/klzgrad/naiveproxy"
SRC_URI="
	amd64? ( https://github.com/klzgrad/naiveproxy/releases/download/v${MY_PV}/naiveproxy-v${MY_PV}-linux-x64.tar.xz )
	x86? ( https://github.com/klzgrad/naiveproxy/releases/download/v${MY_PV}/naiveproxy-v${MY_PV}-linux-x86.tar.xz )
	arm? ( https://github.com/klzgrad/naiveproxy/releases/download/v${MY_PV}/naiveproxy-v${MY_PV}-linux-arm.tar.xz )
	arm64? ( https://github.com/klzgrad/naiveproxy/releases/download/v${MY_PV}/naiveproxy-v${MY_PV}-linux-arm64.tar.xz )
	riscv? ( https://github.com/klzgrad/naiveproxy/releases/download/v${MY_PV}/naiveproxy-v${MY_PV}-linux-riscv64.tar.xz )
"

LICENSE="BSD-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~arm ~arm64 ~riscv"
RESTRICT="mirror"

RDEPEND="
	!net-proxy/naiveproxy
"

QA_PREBUILT="
	/opt/naiveproxy/naive
"

if [[ ${ARCH} == amd64 ]]; then
	MY_ARCH=x64
elif [[ ${ARCH} == riscv ]]; then
	MY_ARCH=riscv64
else
	MY_ARCH=${ARCH}
fi

S=${WORKDIR}/naiveproxy-v${MY_PV}-linux-${MY_ARCH}

src_install() {
	insinto /opt/naiveproxy
	doins config.json naive USAGE.txt
	fperms +x /opt/naiveproxy/naive
	dosym /opt/naiveproxy/naive /usr/bin/naive
}
