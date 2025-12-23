# Documentation: OpenVPN Client for Home Assistant

This add-on enables you to tunnel your Home Assistant traffic through an OpenVPN connection. Depending on your configuration, you can route all or part of your server's communication through the VPN.

## Setup and Configuration

Follow these steps to get up and running:

1. Prepare Folders: Create a directory named openvpn inside your /config/ folder.
2. Upload Files: Copy your .ovpn configuration file into /config/openvpn/. If your provider uses separate certificates (.crt) or keys (.key), place them in the same folder.
3. Configure Add-on:
   - Go to the Configuration tab of the add-on.
   - Enter the full path to your config file (Example: /config/openvpn/client.ovpn).
   - Enter your credentials if required by your provider.
4. Start: Click Start and check the Logs tab to verify the connection status.

## Authentication Methods

The add-on dynamically adapts to your security requirements:

* Certificate-only: Leave username and password blank.

* Credentials: Provide username and password. The add-on securely generates a temporary authentication file at runtime.

* Encrypted Private Key: Use the "Private key password" field to provide the decryption passphrase.

## Troubleshooting

1. Check the Logs: Most connection issues (auth failure, TLS errors) are explicitly detailed in the add-on Logs tab.

2. File Permissions: Ensure your .ovpn file is readable and located in the correct /config/openvpn directory.

3. DNS Issues: Depending on your VPN provider, you might need to add customargs: "--pull-filter ignore \"route-gateway\"" if you experience local network connectivity loss.

## Security

* Temporary Files: Credentials and passphrases are stored in /tmp/ (RAM) and are automatically deleted when the add-on stops.

* Hardening: It is recommended to use a dedicated VPN account with limited privileges.

## License

MIT License. See LICENSE for more information.