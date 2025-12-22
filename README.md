# 🛡️ OpenVPN Client for Home Assistant

This add-on enables you to tunnel your Home Assistant traffic through an **OpenVPN** connection. Depending on your configuration, you can route all or part of your server's communication through the VPN.

## 🚀 Installation

1. Go to the **Add-on Store** in your Home Assistant instance.
2. Click **⋮ (Menu) → Repositories**.
3. Add the following URL:  
   `https://github.com/rofra/homeassistant-openvpn-client-addon`
4. Click **Add**, then **Close**.
5. Find the **OpenVPN Client** add-on and click **Install**.

[![Open Repository](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Frofra%2Fhomeassistant-openvpn-client-addon)

## ⚙️ Setup & Configuration

Follow these steps to get up and running:

1. **Prepare Folders:** Create a directory named `openvpn` inside your `/config/` folder.
2. **Upload Files:** Copy your `.ovpn` configuration file (and any required certificate or password files) into `/config/openvpn/`.
3. **Configure Add-on:**
   - Go to the **Configuration** tab of the add-on.
   - Enter the full path to your config file (e.g., `/config/openvpn/client.ovpn`).
   - Enter your **Username** and **Password** if required by your VPN provider.
4. **Start:** Click **Start** and check the **Logs** tab to verify the connection.

## 🔐 Authentication Methods

The add-on supports two main authentication flows:

* **Basic Authentication:** Uses standard credentials (Username + Password).
* **Certificate Decryption:** If your private key is encrypted, provide the path to the password file used to decrypt it.

---

**Note:** Ensure the file paths in the configuration match the actual location of your files in the `/config/openvpn` directory.