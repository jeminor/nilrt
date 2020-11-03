How to start using this project to run a build container?
1. Edit the docker-compose.yml to match whatever dirs/user you want to map into the container and grab whatever version of the container you see fit (or just use the built Dockerfile).
2. docker-compose -f docker-compose.yml up oebuild  (starts the container)
3. docker exec -it docker_oebuild_1 /bin/bash (connect to the container)
