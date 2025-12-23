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

## Installation

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Frofra%2Fhomeassistant-openvpn-client-addon)

