# Documentation: OpenVPN Client for Home Assistant

This add-on enables you to tunnel your Home Assistant traffic through an OpenVPN connection. Depending on your configuration, you can route all or part of your server's communication through the VPN.

## Setup and Configuration

Follow these steps to get up and running:

1. **Prepare Folders**: Create a directory named `openvpn` inside your `/config/` folder.
2. **Upload Files**: Copy your `.ovpn` configuration file into `/config/openvpn/`. If your provider uses separate certificates (`.crt`) or keys (`.key`), place them in the same folder.
3. **Configure Add-on**:
   - Go to the **Configuration** tab of the add-on.
   - Enter the full path to your config file (Example: `/config/openvpn/client.ovpn`).
   - Enter your credentials if required by your provider.
4. **Start**: Click **Start** and check the **Logs** tab to verify the connection status.

## Authentication Methods

The add-on dynamically adapts to your security requirements using the **Bashio** framework:

* **Certificate-only**: Leave username and password blank.
* **Credentials**: Provide username and password. The add-on securely generates a temporary authentication file in RAM (`/tmp/`) at runtime.
* **Encrypted Private Key**: Use the `ovpnpass` field to provide the decryption passphrase for your private key.

## Troubleshooting

1. **Check the Logs**: Most connection issues (auth failure, TLS errors) are explicitly detailed in the add-on Logs tab with color-coded severity.
2. **File Not Found**: Ensure the path in the configuration exactly matches the file location. Linux is case-sensitive.

## Security

* **Temporary Files**: Credentials and passphrases are stored in `/tmp/` (tmpfs/RAM) and are automatically wiped when the add-on stops.
* **Process Management**: The add-on uses `exec` to ensure OpenVPN runs as PID 1, allowing it to handle system signals and close the tunnel cleanly.
* **Hardening**: It is recommended to use a dedicated VPN account with limited privileges.

## Installation

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Frofra%2Fhomeassistant-openvpn-client-addon)

## License

MIT License. See LICENSE for more information.