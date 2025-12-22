#!/usr/bin/env bash
set +u

# Extract variables from module configuration
CONFIG_PATH=/data/options.json
OPENVPN_CONFIG="$(jq --raw-output '.ovpnfile' $CONFIG_PATH)"
OPENVPN_CONFIG_PASS="$(jq --raw-output '.ovpnpassfile' $CONFIG_PATH)"
USERNAME="$(jq --raw-output '.username' $CONFIG_PATH)"
PASSWORD="$(jq --raw-output '.password' $CONFIG_PATH)"

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

    if [[ -n "${OPENVPN_CONFIG_PASS}" ]] && [[ ! -f ${OPENVPN_CONFIG_PASS} ]]; then
        echo "Error: we could not find the password file ${OPENVPN_CONFIG_PASS}"
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
if [[ -n "${OPENVPN_CONFIG_PASS}" ]]; then
    echo "Using private key password"
    PASS_OPTION="--askpass ${OPENVPN_CONFIG_PASS}"
else
    echo "No private key password file, skipping"
fi

AUTH_OPTION=""
if [[ -n "${USERNAME}" ]] && [[ -n "${PASSWORD}" ]]; then
    echo "Using provided username and password"

    AUTH_FILE_PATH="/tmp/auth.txt"
    echo "${USERNAME}" > ${AUTH_FILE_PATH}
    echo "${PASSWORD}" >> ${AUTH_FILE_PATH}
    chmod 600 ${AUTH_FILE_PATH}
    AUTH_OPTION="--auth-user-pass ${AUTH_FILE_PATH}"
else
    echo "No username and password provided, skipping auth-user-pass"
fi

# try to connect to the server using the user-defined configuration and credentials (if provided)
echo "openvpn ${PASS_OPTION} ${AUTH_OPTION} --config ${OPENVPN_CONFIG}"
openvpn ${PASS_OPTION} ${AUTH_OPTION} --config ${OPENVPN_CONFIG}