# Home Assistant Add-on: OpenVPN Client

![aarch64](https://img.shields.io/badge/aarch64-yes-green.svg?style=flat-square)
![amd64](https://img.shields.io/badge/amd64-yes-green.svg?style=flat-square)
![armhf](https://img.shields.io/badge/armhf-yes-green.svg?style=flat-square)
![armv7](https://img.shields.io/badge/armv7-yes-green.svg?style=flat-square)
![i386](https://img.shields.io/badge/i386-yes-green.svg?style=flat-square)

This add-on connects your Home Assistant instance to an **OpenVPN** server to encrypt and mask your outgoing traffic.

## About

**OpenVPN** is a robust and highly flexible VPN protocol. This add-on acts as an OpenVPN **client** inside your Home Assistant ecosystem.

When started, it creates a secure, encrypted tunnel between your Home Assistant instance and a remote VPN server. This process:
1.  **Encrypts** all outgoing traffic from the add-on's environment.
2.  **Masks** your real IP address with the IP provided by the VPN service.
3.  **Secures** communications against local network snooping and ISP tracking.

