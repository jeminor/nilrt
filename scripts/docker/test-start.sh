#!/bin/bash
set -xeuo pipefail

if [ "${1:-}" = "prune" ]; then
	docker image rm nilrt-build:sumo
fi
docker build $(if [ "${1:-}" = "prune" ]; then echo --no-cache; fi) -f Dockerfile.nilrt -t nilrt-build:latest .
#docker run -i -t nilrt-build:sumo `id -u` `id -g`
#./nilrt-container-cli/nilrt-container -d start nilrt/master/sumo
./nilrt-container-cli/nilrt-container -d start ~/projects/nilrt-sumo
