#!/bin/bash

# Port Set Karna
sed -i "s/PORT_PLACEHOLDER/$PORT/g" config.json

echo "Railway V2Ray Core Started on Port $PORT..."

# Direct Binary Run (No more script errors)
./system_core run -c config.json
