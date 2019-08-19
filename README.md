# Mutagen Development Environment Template

## Installation

### MacOS (or Linux with Homebrew)

```Bash
brew install mutagen-io/mutagen/mutagen
```

### Ubuntu - Linux

```Bash
mkdir -p ~/mutagen_bin && cd ~/mutagen_bin
curl -L https://github.com/mutagen-io/mutagen/releases/download/v0.10.0/mutagen_linux_amd64_v0.10.0.tar.gz | tar xz
sudo install -t /usr/local/bin/ mutagen
sudo install -t /usr/local/bin/ mutagen-agents.tar.gz
rm -rf ~/mutagen_bin
```

## Use mutagen with Orchestration - sync/forward as code

- In project folder there has to exist a global configuration file `mutagen.yml`. [Example global configuration file](./mutagen.yml)

```Bash
mutagen project start
# if mutagen.yml is named any other way e.g. mutagen-custom.yml, you can invoke the command as follows

mutagen project start mutagen-custom.yml
```

## Mutagen Docker Socket Forwarded via Forwards

```YAML
forward:
  defaults:
    socket:
      overwriteMode: "overwrite"
  remoteDocker:
    source: "tcp:localhost:23750"
    destination: "user@machine-ip-or-dns:unix:/var/run/docker.sock"
    # or you can use an ~/.ssh/config aware host name such as
    destination: "docker.dev:unix:/var/run/docker.sock"
```

- Export Docker env vars to connect

```Bash
export DOCKER_HOST=tcp://localhost:23750
# Compatibility with Server API, our client by default uses API v1.40, since it is Version: 19.03.1
export DOCKER_API_VERSION=1.39
```

- Or use the helper `docker_client.env` file, after modifying `<docker-daemon-host>:<port>` & `API_VERSION` variables

```Bash
source docker_client.env
```

- Now docker commands send context to remote daemon

```Bash
docker build -t test_mutagen:latest .

Sending build context to Docker daemon  80.38kB
Step 1/2 : FROM python:3.6-slim
 ---> 8aa59c33d0d5
Step 2/2 : RUN mkdir -p /usr/src/app
 ---> Running in 8bd070aadc9d
Removing intermediate container 8bd070aadc9d
 ---> 74409dd6285e
Successfully built 74409dd6285e
Successfully tagged test_mutagen:latest
```

## Setup Docker Client with Forwarded Socket/Port Manually

```Bash
ssh -nNT -L $(pwd)/docker.sock:/var/run/docker.sock user@machine-ip-or-dns &
export DOCKER_HOST="unix:///$(pwd)/docker.sock"

# or to store in a central folder location
ssh -nNT -L ${HOME}/docker_sockets/docker.sock:/var/run/docker.sock user@machine-ip-or-dns &
export DOCKER_HOST=unix:///${HOME}/docker_sockets/docker.sock

# Compatibility with Server API, our client by default uses API v1.40, since it is Version: 19.03.1
export DOCKER_API_VERSION=1.39

# Debug with docker version or docker info
docker version

Client: Docker Engine - Community
 Version:           19.03.1
 API version:       1.39
 Go version:        go1.12.5
 Git commit:        74b1e89e8a
 Built:             Thu Jul 25 21:21:35 2019
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          18.09.2
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.6
  Git commit:       6247962
  Built:            Sun Feb 10 03:42:13 2019
  OS/Arch:          linux/amd64
  Experimental:     false

```

## Demo Usage

- The current demo has 2 mutagen orchestration files.
- [mutagen-remote-docker.yml](./mutagen-remote-docker.yml) forwards the `/var/run/docker.sock` to `localhost:23750` in order to connect the docker client
- [mutagen.yml](./mutagen.yml) is the `global configuration file` and syncs `test_folder` and also forwards `portainer` http port.

```Bash
# Forward the docker daemon & export appropriate docker environment variables to connect with the server
mutagen project start mutagen-remote-docker.yml --no-global-configuration
export DOCKER_HOST=tcp://localhost:23750
export DOCKER_API_VERSION=1.39

# Start the portainer service on remote dev server, as described in portainer.yml file
docker-compose -f portainer.yml up -d portainer

# Use the global configuration file mutagen.yml to reverse proxy port 9000 (Portainer) & sync test_folder.
mutagen project start

# Make some edits on test_file.txt and use below command to monitor changes
mutagen sync monitor
```
