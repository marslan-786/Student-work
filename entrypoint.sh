#!/bin/bash

# Railway ka Port Config me lagana
sed -i "s/PORT_PLACEHOLDER/$PORT/g" config.json

echo "System Started using LOCAL FILES on Port $PORT..."

# Server Start
./system_core run -c config.json
