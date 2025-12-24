#!/usr/bin/with-contenv bashio
set -e

# --- SETUP ---
# Fetch options from Home Assistant
OPENVPN_CONFIG=$(bashio::config 'ovpnfile')
OPENVPN_DECRYPTIONPASS=$(bashio::config 'ovpnpass')
USERNAME=$(bashio::config 'username')
PASSWORD=$(bashio::config 'password')
CUSTOMARGS=$(bashio::config 'customargs')

# --- TUN INTERFACE ---
# Create device if missing
if [ ! -c /dev/net/tun ]; then
    bashio::log.info "Initializing tun interface"
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
fi

# --- CONFIG CHECK ---
# Wait for the configuration file to be available
while ! bashio::fs.file_exists "${OPENVPN_CONFIG}"; do
    bashio::log.warning "Waiting for configuration file"
    sleep 10
done

# --- AUTHENTICATION ---
PASS_OPTION=""
if bashio::config.has_value 'ovpnpass'; then
    bashio::log.info "Setting up decryption passphrase"
    echo "${OPENVPN_DECRYPTIONPASS}" > /tmp/pass.txt
    chmod 600 /tmp/pass.txt
    PASS_OPTION="--askpass /tmp/pass.txt"
fi

AUTH_OPTION=""
if bashio::config.has_value 'username' && bashio::config.has_value 'password'; then
    bashio::log.info "Setting up credentials file"
    echo "${USERNAME}" > /tmp/auth.txt
    echo "${PASSWORD}" >> /tmp/auth.txt
    chmod 600 /tmp/auth.txt
    AUTH_OPTION="--auth-user-pass /tmp/auth.txt"
fi

# --- EXECUTION ---
# Standard args to avoid DNS errors
ARGS_OPTION="--pull-filter ignore block-outside-dns"
if bashio::config.has_value 'customargs'; then
    ARGS_OPTION="${ARGS_OPTION} ${CUSTOMARGS}"
fi

bashio::log.info "Starting OpenVPN"
# Exec ensures OpenVPN handles termination signals properly
exec openvpn ${PASS_OPTION} ${AUTH_OPTION} ${ARGS_OPTION} --config "${OPENVPN_CONFIG}"