ARG BUILD_FROM
FROM $BUILD_FROM

# Install only openvpn
RUN apk add --no-cache openvpn

# Create the s6 service directory
RUN mkdir -p /etc/services.d/openvpn

# Copy the script and rename it to 'run' for s6-overlay
COPY run.sh /etc/services.d/openvpn/run

# Grant execution permissions
RUN chmod a+x /etc/services.d/openvpn/run

# No CMD or ENTRYPOINT needed, s6 starts services in /etc/services.d/ automatically