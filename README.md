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

### Arguments

* `rustdesk_ajspec` (default: `gh+AppJail-makejails/rustdesk`): Entry point where the `appjail-ajspec(5)` file is located.
* `rustdesk_tag` (default: `13.5`): see [#tags](#tags).

## Tags

| Tag           | Arch    | Version            | Type   |
| ------------- | --------| ------------------ | ------ |
| `13.5`    | `amd64` | `13.5-RELEASE` | `thin` |
| `14.3`    | `amd64` | `14.3-RELEASE` | `thin` |

## Acknowledgments

* @alonsobsd
