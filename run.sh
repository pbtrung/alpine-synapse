#!/bin/sh

source /synapse/bin/activate
python3 -m heisenbridge -c /data/heisenbridge.yaml --generate
# python3 -m synapse.app.homeserver --server-name $SYNAPSE_SERVER_NAME --config-path /data/homeserver.yaml --generate-missing-config --report-stats=no
synctl --no-daemonize start /data/homeserver.yaml