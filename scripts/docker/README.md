How to start using this project to run a build container?
1.  Install python3 and python3-pip on your host.
2.  Install package dependencies from the requirements file -
    `pip3 install -r ./nilrt-container-cli/requirements`
3.  Install [Docker](https://docs.docker.com/install/linux/docker-ce/debian/)
4.  Follow [instructions]
    (https://docs.docker.com/install/linux/linux-postinstall/) to start the
    docker daemon post installation.
5.  Install p4 CLI and set up a perforce and penguin workspace host. Ensure
    that the p4 clients are not associated with the host name. To confirm, run
    `p4 client` and delete the host entry for both the workspaces. This will
    ensure that the workspaces can be accessed from within the container.
6.  Login to the p4 workspaces and generate p4 tickets - `p4 login -a`. The
    tickets file will be located in ~/.p4tickets, by default.
7.  Mount argo/RnD, nirvana/perforceExports and penguin/balticExports on the
    host.
8.  Optional: If you are going to be working in the OE nilrt repos, obtain
    write permissions by providing your ssh RSA public key to the
    git.natinst.com administrator. To ensure that you have access, run
    `ssh -T git@git.natinst.com` on the host. This command should not request
    a password and list the repos hosted on git.natinst.com.
9.  Look up the nilrt-container.conf.example file in this project. This file
    has all the configuration you will need to set to get started with the
    build containers. Copy this file into a new .conf file and update the file
    with all the mount points, ssh key, p4 setup, etc. you created above,
    including preferred user id, group id, Docker image name, etc.
    NOTE: Set the perforce and penguin bind-mounts dest the same as the src so
    that when you are logged into the container, you do not have to change the
    workspace root because it matches what was on the host.
10. Run `./nilrt-container-cli/nilrt-container -c <conf_file> -d build` from
    the docker directory. This will build the docker image based on
    instructions in _Dockerfile.nilrt_. Use the `-p` option to clean up the
    workspace removing existing containers and images.
11. Run `./nilrt-container-cli/nilrt-container -c <conf_file> -d start`. This
    will start a container interactively from the image with the provided
    config. The container is set up with p4 and git workspaces and bash started
    in the git project. The bash shell in the container is started such that
    exit codes under 200 will not exit the container. To exit the container,
    run `exit_container`.
12. If the container enters _Recovery mode_, run `source ~/.bashrc` to set up
    the build environment again.


TODO

- git error when syncing submodules?
Entering 'sources/meta-security'
/usr/lib/git-core/git-submodule: line 347: [: too many arguments
