# Reverse SSH Tunnel with Obfuscated SSH Binary

This repository provides a method to establish a reverse SSH tunnel with an obfuscated handshake, preventing Layer 7 firewalls from blocking the traffic. The solution consists of two containers:
- **Internal container**: Deployed inside the firewall, it initiates the connection to the external container and creates the reverse SSH tunnel.
- **External container**: Deployed outside the firewall, it remains publicly accessible to receive connections and it creates a SOCKS5 proxy that tunnels the traffic to the "in" container.

## Deployment Steps

1. **Deploy the external container** (`out`) in an environment outside the firewall. 
   - It needs at least two ports, by default 8443 to receive SSH connections, and port 8089 to serve the SOCKS5 proxy.
2. **Expose the external container to the internet**:
   - By default, the `out` container listens on port `8443` for incoming connections. You can either expose `8443` directly or use NAT to map another external port (e.g., `443` or any commonly open port) to internal `8443`.
3. **Deploy the internal container** (`in`) inside the firewall:
   - Use the provided `deployment.yaml` file to deploy it in OpenShift or the run.sh script for Linux, but be sure that you include the right environment variable in any case (mainly IP and Port where you published the "out" container)
4. **Configure your web browser to use the SOCKS5 proxy**:
   - Set the proxy to point to the external container (`out`) on port `8089`.
   - Optionally, use the provided `proxy.pac` file to redirect only specific traffic through the proxy. Update `proxy.pac` with the correct values for `myinternaldomain.com` and `myoutcontainerip`.

## Notes
- Ensure the external container remains accessible from the internal container.
- Use a commonly allowed ports (80, 443, 8443, ...) to improve reliability in restrictive environments.

