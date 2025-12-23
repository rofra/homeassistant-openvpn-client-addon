#!/usr/bin/with-conten-env bashio
set -e

# --- 1. SETUP ---
CONFIG_PATH=/data/options.json

OPENVPN_CONFIG=$(bashio::config 'ovpnfile')
OPENVPN_DECRYPTIONPASS=$(bashio::config 'ovpnpass')
USERNAME=$(bashio::config 'username')
PASSWORD=$(bashio::config 'password')
CUSTOMARGS=$(bashio::config 'customargs')

# --- 2. TUN INTERFACE ---
if [ ! -c /dev/net/tun ]; then
    bashio::log.info "Creating tun interface"
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
fi

# --- 3. CONFIG CHECK ---
while ! bashio::fs.file_exists "${OPENVPN_CONFIG}"; do
    bashio::log.warning "Waiting for: ${OPENVPN_CONFIG}"
    sleep 10
done

# --- 4. AUTHENTICATION ---
PASS_OPTION=""
if bashio::config.has_value 'ovpnpass'; then
    bashio::log.info "Setting up key passphrase"
    PASS_FILE_PATH="/tmp/pass.txt"
    echo "${OPENVPN_DECRYPTIONPASS}" > "${PASS_FILE_PATH}"
    chmod 600 "${PASS_FILE_PATH}"
    PASS_OPTION="--askpass ${PASS_FILE_PATH}"
fi

AUTH_OPTION=""
if bashio::config.has_value 'username' && bashio::config.has_value 'password'; then
    bashio::log.info "Setting up user/pass auth"
    AUTH_FILE_PATH="/tmp/auth.txt"
    echo "${USERNAME}" > "${AUTH_FILE_PATH}"
    echo "${PASSWORD}" >> "${AUTH_FILE_PATH}"
    chmod 600 "${AUTH_FILE_PATH}"
    AUTH_OPTION="--auth-user-pass ${AUTH_FILE_PATH}"
fi

# --- 5. ARGUMENTS & EXEC ---
ARGS_OPTION="--pull-filter ignore block-outside-dns"
if bashio::config.has_value 'customargs'; then
    ARGS_OPTION="${ARGS_OPTION} ${CUSTOMARGS}"
fi

bashio::log.info "Starting OpenVPN"
exec openvpn ${PASS_OPTION} ${AUTH_OPTION} ${ARGS_OPTION} --config "${OPENVPN_CONFIG}"