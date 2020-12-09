#!/bin/sh
set -e

# Based on https://github.com/nodejs/docker-node
# License: https://github.com/nodejs/docker-node/blob/master/LICENSE

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
    set -- node "$@"
fi

exec "$@"
