# qv2ray-overlay
Overlay for [Qv2ray](https://github.com/Qv2ray/Qv2ray).

This overlay contains Qv2ray, its plugins and (part of) their dependencies. 

## Usage
`eselect repository enable qv2ray-overlay`

## Warning
Qv2ray and its plugins are no longer maintained: https://github.com/Qv2ray/Deprecation-Notice (actually Qv2ray still has certain maintenance)

## Dependencies
* net-proxy/v2ray:
  * v5: [gentoo-zh](https://github.com/microcai/gentoo-zh)
  * v4: here (need <dev-lang/go-1.20 (also here))
* net-proxy/v2ray-bin, net-proxy/Xray, app-alternatives/v2ray-geo{ip,site}: gentoo-zh
* net-proxy/naiveproxy: [chiyuki-overlay](https://github.com/IllyaTheHath/gentoo-overlay)
* net-proxy/naiveproxy-bin, net-proxy/trojan-go{,-fork}{,-bin}: here

## Contributing
I'm not very experienced in writing ebuilds, if you find any issues, feel free to contribute.

Also, please help to fix packages in package.mask!
