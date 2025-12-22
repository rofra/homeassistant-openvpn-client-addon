#!/usr/bin/env bash
set +u

# Setup cleanup on exit
trap 'rm -f /tmp/auth.txt /tmp/pass.txt; exit 0' SIGINT SIGTERM EXIT

# Extract variables from module configuration
CONFIG_PATH=/data/options.json

OPENVPN_CONFIG="$(jq --raw-output '.ovpnfile' $CONFIG_PATH)"
OPENVPN_DECRYPTIONPASS="$(jq --raw-output '.ovpnpass' $CONFIG_PATH)"
USERNAME="$(jq --raw-output '.username' $CONFIG_PATH)"
PASSWORD="$(jq --raw-output '.password' $CONFIG_PATH)"
CUSTOMARGS="$(jq --raw-output '.customargs' $CONFIG_PATH)"

# Prepare needed variables
BASEDIRECTORY="/config/openvpn"

########################################################################################################################
# Initialize the tun interface for OpenVPN if not already available
########################################################################################################################
function init_tun_interface(){
    # create the tunnel for the OpenVPN client
    mkdir -p /dev/net
    if [ ! -c /dev/net/tun ]; then
        mknod /dev/net/tun c 10 200
    fi
}
########################################################################################################################
# Check if all required files are available.
########################################################################################################################
function check_files_available(){
    failed=0

    if [[ ! -f ${OPENVPN_CONFIG} ]]; then
        echo "Error: we could not find the OVPN file ${OPENVPN_CONFIG}"
        echo ""
        failed=1
    fi

    if [[ ${failed} == 0 ]]; then
        return 0
    else
        return 1
    fi
}

########################################################################################################################
# Wait until the user has uploaded all required certificates and keys in order to setup the VPN connection.
########################################################################################################################
function wait_configuration(){
    echo "Waiting for user to put the OpenVPN configuration file in"
    # therefore, wait until the user upload the required certification files
    while true; do
        check_files_available

        if [[ $? == 0 ]]; then
            break
        fi

        sleep 5
    done
    echo "All files available!"
}

# init interfaces
init_tun_interface

# wait until the user uploaded the configuration files
wait_configuration

echo ""
echo ""
echo "Setting up the VPN connection with the following OpenVPN configuration: ${OPENVPN_CONFIG}"
echo ""
echo ""

PASS_OPTION=""
if [[ -n "${OPENVPN_DECRYPTIONPASS}" ]]; then
    echo "Private key password detected. Preparing password file..."

    PASS_FILE_PATH="/tmp/pass.txt"
    # Write the passphrase to a temporary file for the --askpass option
    printf "%s\n" "${OPENVPN_DECRYPTIONPASS}" > "${PASS_FILE_PATH}"
    
    chmod 600 "${PASS_FILE_PATH}"
    PASS_OPTION="--askpass ${PASS_FILE_PATH}"
else
    echo "No private key password provided. Skipping..."
fi

AUTH_OPTION=""
if [[ -n "${USERNAME}" ]] && [[ -n "${PASSWORD}" ]]; then
    echo "Authentication credentials detected. Preparing credentials file..."

    AUTH_FILE_PATH="/tmp/auth.txt"
    # Securely write credentials to a temporary file
    printf "%s\n" "${USERNAME}" > "${AUTH_FILE_PATH}"
    printf "%s\n" "${PASSWORD}" >> "${AUTH_FILE_PATH}"
    
    chmod 600 "${AUTH_FILE_PATH}"
    AUTH_OPTION="--auth-user-pass ${AUTH_FILE_PATH}"
else
    echo "No VPN credentials provided. Skipping authentication..."
fi

ARGS_OPTION=""
if [[ -n "${CUSTOMARGS}" ]]; then
    echo "Applying custom OpenVPN arguments: ${CUSTOMARGS}"
    # Assign without quotes to allow Bash to split multiple arguments correctly
    ARGS_OPTION=${CUSTOMARGS}
else
    echo "No custom arguments provided. Using default configuration."
fi


# try to connect to the server
openvpn ${PASS_OPTION} ${AUTH_OPTION} ${ARGS_OPTION} --config ${OPENVPN_CONFIG}