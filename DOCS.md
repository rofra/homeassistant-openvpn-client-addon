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

The add-on supports two main authentication flows:

* Certificate Decryption: If your private key is password-protected, use the Private Key Password field to provide the decryption passphrase.
* Basic Authentication: Use the Username and Password fields for standard service credentials. These are securely handled in RAM during execution.

## Troubleshooting

### Connection fails immediately
Check the Logs tab. If you see "Infile not found", verify that the path in the configuration matches the actual file location in your config folder. Note that Linux is case-sensitive.

### Authentication Failed
Ensure you are using the correct credentials. Many VPN providers use specific "Service Credentials" for OpenVPN which are different from your main account login.

### No internet access
Some network configurations require specific arguments. You can try adding "--pull-filter ignore route-gateway" to the Custom Arguments field if you lose connectivity to your local network.

## Security and Privacy

All sensitive data, such as passwords and passphrases, are stored in a temporary memory-based filesystem