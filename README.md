# Ingress Mesh BGP

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This pattern demonstrates the use of metallb and the gateway api.

See [this](./docs/network.svg) diagram for more information.

## Installation

First deploy the west (hub) and east (spoke) clusters. See
./docs/install-configs for two examples. Purely for simplicity reasons, we use
a single AZ.

Create a branch (let's call it `mybranch`) and push it out to your github fork
via `git push -u fork mybranch`.

Once both clusters are deployed set the following environment variables and run the
target that will create the client vm, core frr and two tors:

```sh
export WESTCONFIG=~/west-hub/auth/kubeconfig \
  EASTCONFIG=~/east-spoke/auth/kubeconfig
make bgp-routing
```

Read the IP addresses of the TOR nics in the OCP worker subnet:

```sh
"west_ip": "10.0.72.219"
"east_ip": "10.1.124.179",
```

Put the `west_ip` in `values-west.yaml` in the metallb overrides and the
`east_ip` in the `values-east.yaml` overrides. Commit the changes and push them
up to your fork.

Then install the pattern on the west (hub) cluster:

```sh
export KUBECONFIG=~/west-hub/auth/kubeconfig
./pattern.sh make install
```

Once the pattern is installed, import the `east` cluster (spoke) into the hub:

```sh
make import
```

## Verify setup

The `make bgp-routing` command generates a `/tmp/launch_tmux.sh` command which configures
a tmux with an ssh session on each EC2 vm.

Hop on the client vm tab and run `curl http://192.168.155.151/hello`
