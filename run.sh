#!/usr/bin/with-contenv bashio
set -e

# --- SETUP ---
# Fetch options from Home Assistant
OVPN_RAW=$(bashio::config 'ovpncontent')
OPENVPN_DECRYPTIONPASS=$(bashio::config 'ovpnpass')
USERNAME=$(bashio::config 'username')
PASSWORD=$(bashio::config 'password')
CUSTOMARGS=$(bashio::config 'customargs')

CLIENTFILEPATH="/tmp/client.ovpn"

# --- TUN INTERFACE ---
# Create device if missing
if [ ! -c /dev/net/tun ]; then
    bashio::log.info "Initializing tun interface"
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
fi

# --- CONFIG PREPARATION ---
if ! bashio::config.has_value 'ovpncontent'; then
    bashio::log.error "The 'ovpncontent' list is empty. Please add items in the configuration."
    exit 1
fi

bashio::log.info "Creating configuration file from list items..."
# Clear the file first
true > "${CLIENTFILEPATH}"

bashio::log.info ${OVPN_RAW}

# Correct way to iterate over a list in bashio without breaking on spaces
# This reads the list from the JSON config and writes each item as a full line
printf "%b" "${OVPN_RAW}" > "${CLIENTFILEPATH}"
bashio::log.info "File created"

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
exec openvpn ${PASS_OPTION} ${AUTH_OPTION} ${ARGS_OPTION} --config "${CLIENTFILEPATH}"