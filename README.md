# Ingress Mesh BGP

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This pattern demonstrates the use of metallb and the gateway API.

See [this](./docs/network.svg) diagram for more information.

## Installation

First deploy the west (hub) and east (spoke) clusters. See
[this](./docs/install-configs/) folder for two examples. Purely for simplicity
reasons, we use a single AZ by default.

Create a branch (let's call it `mybranch`) and push it out to your GitHub fork
via `git push -u fork mybranch`.

Once both clusters are deployed set the following environment variables and run
the target that will create the client vm, core frr and two tors:

```sh
export WESTCONFIG=~/west-hub/auth/kubeconfig \
  EASTCONFIG=~/east-spoke/auth/kubeconfig
make bgp-routing
```

If you have used the install-config files [listed here](./docs/install-configs)
then there is nothing else to do.

**note:** If you used your custom `install-config.yaml` files then you will
need to tweak the `metal.peerAddress` in `./values-west.yaml` and in
`./values-east.yaml`. Then make sure you push the change in to your `mybranch`.

At this point you can install the pattern on the `west` (hub) cluster (by default
it will install the pattern on the cluster pointed to by the WESTCONFIG
environment variable)

```sh
./pattern.sh make install
```

Once the pattern is fully installed (this can be checked by looking at the
`West ArgoCD` instance in the nine-box and verifying that all applications are
green there) import the `east` spoke cluster into the `west` hub:

```sh
make import
```

## Verify setup

The `make bgp-routing` command generates a `/tmp/launch_tmux.sh` command which configures
a tmux with an SSH session on each EC2 vm.

Hop on the client vm tab and run `curl http://192.168.155.151/hello`

## Destroy setup

First run `make bgp-routing-cleanup` and *then* destroy the two clusters
