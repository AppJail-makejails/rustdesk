#!/bin/sh

set -e

. /lib.subr


if [ "$1" = "hbbs" ] || [ "$1" = "hbbr" ]; then
    create_user

    export HOME=/noroot

    if [ "$(pwd)" = "/" ]; then
        cd "${HOME}"
    fi

    set -- su-exec noroot "$@"
fi

exec "$@"
