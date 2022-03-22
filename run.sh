#!/bin/sh

source /synapse/bin/activate
python3 -m mautrix_facebook -g -c /data/facebook-config.yaml -r /data/facebook-registration.yaml
# python3 -m synapse.app.homeserver --server-name $SYNAPSE_SERVER_NAME --config-path /data/homeserver.yaml --generate-missing-config --report-stats=no
python3 -m mautrix_facebook
synctl --no-daemonize start /data/homeserver.yaml