function FindProxyForURL(url, host) {

    if (shExpMatch(host, "*.myinternaldomain.com") ||
        shExpMatch(host, "192.168.3.*")) {
        return "SOCKS5 myoutcontainerip:8089";
    }

    // All other traffic goes direct (no proxy)
    return "DIRECT";
}
