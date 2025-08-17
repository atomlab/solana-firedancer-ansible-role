#!/bin/bash

set -e 

/opt/firedancer/bin/fdctl configure init all --config /opt/firedancer/config/config.toml

exec "$@"