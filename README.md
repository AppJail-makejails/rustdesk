# RustDesk

RustDesk-server is a self hosted server for the RustDesk remote desktop software.

wikipedia.org/wiki/RustDesk

<img src="https://gnulinux.ch/bl-content/uploads/pages/f2c4cf4e5cc5182920c2bf5cc3bb5642/RustDesk.png" width="60%" height="auto" alt="rustdesk logo" />

## How to use this Makejail

```sh
appjail makejail \
    -j rustdesk-server \
    -f gh+AppJail-makejails/rustdesk \
    -o alias \
    -o ip4_inherit
```

**Note**: See [RustDesk docs](https://rustdesk.com/docs/en/self-host/) for more information on the ports used.

### Arguments

* `rustdesk_hbbs` (default: `1`): Enable and start the `rustdesk-hbbs` `rc(8)` script.
* `rustdesk_hbbr` (default: `1`): Enable and start the `rustdesk-hbbr` `rc(8)` script.
* `rustdesk_ajspec` (default: `gh+AppJail-makejails/rustdesk`): Entry point where the `appjail-ajspec(5)` file is located.
* `rustdesk_tag` (default: `13.4`): see [#tags](#tags).

### Volumes

| Name         | Owner | Group | Perm | Type | Mountpoint  |
| ------------ | ----- | ----- | ---- | ---- | ----------- |
| rustdesk-db | 319  | 319  |  770   |  -   | /var/db/rustdesk  |

## Tags

| Tag           | Arch    | Version            | Type   |
| ------------- | --------| ------------------ | ------ |
| `13.4`    | `amd64` | `13.4-RELEASE` | `thin` |
| `14.2`    | `amd64` | `14.2-RELEASE` | `thin` |

## Acknowledgments

* @alonsobsd
