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

## Setup Docker Client with Forwarded Socket/Port Manually

```Bash
ssh -nNT -L $(pwd)/docker.sock:/var/run/docker.sock user@machine-ip-or-dns &
export DOCKER_HOST="unix:///$(pwd)/docker.sock"

# or to store in a central location
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
