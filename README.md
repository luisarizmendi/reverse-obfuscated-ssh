# Reverse SSH Tunnel with Obfuscated SSH Binary

This repository provides a method to establish a reverse SSH tunnel with an obfuscated handshake, preventing Layer 7 firewalls from blocking the traffic. The solution consists of two containers:
- **Internal container**: Deployed inside the firewall, it initiates the connection to the external container and creates the reverse SSH tunnel.
- **External container**: Deployed outside the firewall, it remains publicly accessible to receive connections and it creates a SOCKS5 proxy that tunnels the traffic to the "in" container.

## Deployment Steps

1. **Deploy the external container** (`out`) in an environment outside the firewall. You can use the [script](out/deploy/run.sh) or create a [quadlet file](out/deploy/reverse-obfuscated-ssh-out.container) setting the right environment variables.
   - It needs at least two ports, by default 8443 to receive SSH connections, and port 8089 to serve the SOCKS5 proxy.
2. **Expose the external container to the internet**:
   - By default, the `out` container listens on port `8443` for incoming connections. You can either expose `8443` directly or use NAT to map another external port (e.g., `443` or any commonly open port) to internal `8443`.
3. **Deploy the internal container** (`in`) inside the firewall:
   - Use the provided [`deployment.yaml`](in/deploy/deployment.yaml) file to deploy it in OpenShift or the [run.sh script](in/deploy/run.sh)], or the [Quadlet file](in/deploy/reverse-obfuscated-ssh-in.container)] for Linux, but be sure that you include the right environment variable in any case (mainly IP and Port where you published the "out" container)
4. **Access the internal environment**: You can either use the SOCKS5 proxy in your Web browser to access internal webpages or connect with SSH:

   * *Configure your web browser to use the SOCKS5 proxy*:
      - Set the proxy to point to the external container (`out`) on port `8089`.
      - Optionally, use the provided `proxy.pac` file to redirect only specific traffic through the proxy. Update `proxy.pac` with the correct values for `myinternaldomain.com` and `myoutcontainerip`.

   * *Connect using SSH*:
      - SSH to the machine where the `out` container is running in the port `2223` with user `root` and password `OUT_PASS` (by default`R3dh4t1!supersecure`):
            `ssh -p 2223 root@<con-out host IP>`
      - You will login into the `con-out` container, from there you can jump into the `con-in` container running in the internal environment by SSH into `127.0.0.1` on port `9122` with `root` user and password `IN_PASS` (by default`R3dh4t1!`):
            `ssh -p 9122 root@127.0.0.1`
      - At this point you will be on the `con-in` container running in the internal environment so you should be able to jump using SSH into any other host (that is not the host that is running the `con-in` container).

## Notes
- It could take some time to create the connection and until the connection is not created the proxy won't work.
- Ensure the external container remains accessible from the internal container.
- Use a commonly allowed ports (80, 443, 8443, ...) to improve reliability in restrictive environments. 
- Some routers could have problems forwarding ports 80 or 443


