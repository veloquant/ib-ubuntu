# Interactive-Brokers Ubuntu

A Docker container encapsulating Interactive Brokers client and gateway.
The client and gateway both run unattended, and the client's GUI is
also made available over VNC.

This is adapted from the recipe by Robert Laverty provided [here](https://github.com/roblav96/headless-ib-gateway-installation-ubuntu-server).

## Building

The build argument IBC_VERSION is provided for selecting the IB client version. If you want to
choose a custom version, use `--build-arg` to specify it.

## Running

First, create an account on Interactive Brokers. Set it up so it would only require password
authentication (i.e. no two-factor).

A container built from this repository is available [on Docker-Hub](https://hub.docker.com/repository/docker/yitzikc/ib-gateway/). Example command for using it:

    docker run --restart=unless-stopped -d -p 5900:5900 -p 4001:44001-e IB_USER=OUR_USER -e IB_PW=OUR_PASSWORD yitzikc/ib-gateway

Ports being exposed:

* 44001: Interactive Brokers gateway. Available from any source address
* 4001: Same as 4001 above, but is only available if IB Client is set-up to listen
on addresses apart from _localhost_. Even if that is configured, only connections
othern than from
the Docker host would require explicit approval on the IBC GUI.
* 5900: VNC port  

## Monitoring

IB Client GUI can be viewed on port 5900 using VLC. Since there's no password, you might want to only
publish this port if actually needed, or only publish it to 127.0.0.1.
