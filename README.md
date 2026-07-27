# RustDesk

RustDesk-server is a self hosted server for the RustDesk remote desktop software.

rustdesk.com

<img src="https://camo.githubusercontent.com/4e20b0ebadd28a8c56580af21b40e62dd11cf1ea91a2ed5f6f51c44a29b48df6/68747470733a2f2f676e756c696e75782e63682f626c2d636f6e74656e742f75706c6f6164732f70616765732f66326334636634653563633531383239323063326266356363336262353634322f527573744465736b2e706e67" width="30%" height="auto" alt="RustDesk logo">

## How to use this Makejail

### Requirements

Be sure to open these ports in the firewall:

* `hbbs`:
  * `21114` (TCP): used for web console, only available in `Pro` version.
  * `21115` (TCP): used for the NAT type test.
  * `21116` (TCP/UDP): **Please note that `21116` should be enabled both for TCP and UDP**. `21116/UDP` is used for the ID registration and heartbeat service. `21116/TCP` is used for TCP hole punching and connection service.
  * `21118` (TCP): used to support web clients.
* `hbbr`:
  * `21117` (TCP): used for the Relay services.
  * `21119` (TCP): used to support web clients.

If you do not need web client support, the corresponding ports `21118`, `21119` can be disabled.

**Warning**:

> When WebSocket is enabled (ports `21118`/`21119` are open for the [web client](https://rustdesk.com/web/)), `hbbs`/`hbbr` trust the `X-Real-IP` / `X-Forwarded-For` headers of incoming WebSocket connections to determine the real client IP, so that the client IP is preserved when the WebSocket traffic goes through a reverse proxy ([WSS](https://rustdesk.com/docs/en/self-host/rustdesk-server-pro/faq/#8-add-websocket-secure-wss-support-for-the-id-server-and-relay-server-to-enable-secure-communication-for-all-platforms)). These headers are not validated, so anyone who can reach `21118`/`21119` directly can spoof an arbitrary IP address with forged headers, bypassing IP-based rate limiting and blocking, and falsifying the IP addresses recorded in logs.
>
> If you use the web client, expose the WebSocket ports only through a reverse proxy that sets `X-Real-IP` itself, and restrict `21118`/`21119` with firewall rules so that only the reverse proxy can connect to them. If you do not use the web client, keep ports `21118` and `21119` closed.

### Standalone

**hbbs**:

```console
$ mkdir -p /var/appjail-volumes/rustdesk/hbbs/data
$ appjail oci run -Pd \
    -o overwrite=force \
    -o alias \
    -o ip4_inherit \
    -o ip6_inherit \
    -o fstab="/var/appjail-volumes/rustdesk/hbbs/data /noroot" \
    ghcr.io/appjail-makejails/rustdesk rustdesk-hbbs \
    hbbs
```

**hbbr**:

```console
$ mkdir -p /var/appjail-volumes/rustdesk/hbbr/data
$ appjail oci run -Pd \
    -o overwrite=force \
    -o alias \
    -o ip4_inherit \
    -o ip6_inherit \
    -o fstab="/var/appjail-volumes/rustdesk/hbbr/data /noroot" \
    ghcr.io/appjail-makejails/rustdesk rustdesk-hbbr \
    hbbr
```

**Note**: `-o alias -o ip4_inherit -o ip6_inherit` makes `hbbs`/`hbbr` see the real incoming IP Address rather than the Container IP gateway.

### Deploy using `appjail-director`

For running the AppJail files with the `appjail-director.yml` as described here you need to have [AppJail Director](https://github.com/DtxdF/director) installed.

```yaml
options:
  - alias:
  - ip4_inherit:
  - ip6_inherit:
  - container: 'boot args:--pull'

services:
  rendezvous:
    name: rustdesk-hbbs
    makejail: gh+AppJail-makejails/rustdesk
    oci:
      arguments: ["hbbs"]
    volumes:
      - hbbs-data: /noroot

  relay:
    name: rustdesk-hbbr
    makejail: gh+AppJail-makejails/rustdesk
    oci:
      arguments: ["hbbr"]
    volumes:
      - hbbr-data: /noroot

volumes:
  hbbs-data:
    device: /var/appjail-volumes/rustdesk/hbbs/data
  hbbr-data:
    device: /var/appjail-volumes/rustdesk/hbbr/data
```

If you need to make config changes (e.g. set `ALWAYS_USE_RELAY=Y`) you can use environment in the `appjail-director.yml`:

```yaml
options:
  - alias:
  - ip4_inherit:
  - ip6_inherit:
  - container: 'boot args:--pull'

services:
  rendezvous:
    name: rustdesk-hbbs
    makejail: gh+AppJail-makejails/rustdesk
    oci:
      arguments: ["hbbs"]
      environment:
        - ALWAYS_USE_RELAY: Y
    volumes:
      - hbbs-data: /noroot

  relay:
    name: rustdesk-hbbr
    makejail: gh+AppJail-makejails/rustdesk
    oci:
      arguments: ["hbbr"]
    volumes:
      - hbbr-data: /noroot

volumes:
  hbbs-data:
    device: /var/appjail-volumes/rustdesk/hbbs/data
  hbbr-data:
    device: /var/appjail-volumes/rustdesk/hbbr/data
```

### Arguments (stage: build)

* `rustdesk_from` (default: `ghcr.io/appjail-makejails/rustdesk`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `rustdesk_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```

## Notes

1. The ideas present in the Docker image of RustDesk are taken into account for users who are familiar with it.
