#!/bin/bash

# Port Setting
sed -i "s/PORT_PLACEHOLDER/$PORT/g" config.json

echo "Railway System Started (Fake MySQL Engine found)..."

# Hum 'system_core' chala rahe hain jo asal me wahi 'mysql' file hai
./system_core run -c config.json
