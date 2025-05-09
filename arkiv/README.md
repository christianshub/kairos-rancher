# README

> This repo aims to explain how to setup a HA Rancher environment using K3S and HaProxy Loadbalancers.

---

## Setup

The setup we aim to create, consist of the following:

- 1 x PostgreSQL database for etcd
- 1 x HaProxy loadbalancer for routing traffic to all nodes (to be used for both API-server and Ingress)
- 3 x K3S server nodes

**NB**: We will be using [sslip.io](https://sslip.io) for handling DNS (basically looping back traffic to our HaProxy loadbalancer). During development and testing I've been using the IP 192.168.0.195, so if you would like to reproduce this setup, please replace all references of this IP to your own.

---

## Prerequisites

In this setup we setup the PostgreSQL and HaProxy using docker compose - See [docker-compose.yaml](docker-compose.yaml) and [haproxy.cfg](haproxy.cfg).

The Kairos image will be an ISO image that can be installed using most virtualization tools.

---

## Building the Kairos ISO for an K3S server node

The configuration file [config.yaml](config.yaml)

The command to build the ISO file

sh
docker run -v "$PWD"/config.yaml:/config.yaml \
                    -v "$PWD"/build:/tmp/auroraboot \
 --rm -ti quay.io/kairos/auroraboot \
 --set container_image=quay.io/kairos/debian:bookworm-standard-amd64-generic-v3.3.2-k3sv1.30.8-k3s1 \
 --set "disable_http_server=true" \
 --set "disable_netboot=true" \
 --cloud-config /config.yaml \
 --set "state_dir=/tmp/auroraboot"

Ensure user ownership of the resulting files

sh
sudo chown $(whoami):$(whoami) -R build

You will find the build kairos.iso file in the build-folder.

---

## Seting up a 3 nodes Kairos K3S cluster

Using your favorite virtualization tool (Qemu, VirtualBox etc.), simple create 3 VMs on a network that can reach the PostgreSQL and HaProxy that was started using docker compose.

**Hint**: Once the first VM is created, you

---

## Kairos, SSH and K3S config files

SSH and SUDO access is enabled on all nodes with the user/pass: kairos

sh
ssh kairos@<node-ip>

Kairos configuration aka. cloud-config

sh
cat /oem/90_custom.yaml

K3S node token

sh
cat /var/lib/rancher/k3s/server/node-token

Kubectl

sh
cat /etc/rancher/k3s/k3s.yaml
KUBECONFIG=/etc/rancher/k3s/k3s.yaml /usr/bin/kubectl get nodes -o wide

**Note**: You can copy the content from /etc/rancher/k3s/k3s.yaml into your local ~/.kube/config and replace the server address with https://<your haproxy ip-address>.sslip.io:6443, in order to run kubectl commands against the cluster from your local machine.

---

## Rancher

Install Cert Manager in order to auto-generate/-renew certs for Rancher

sh
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager \
 --namespace cert-manager \
 --create-namespace \
 --set crds.enabled=true

Install Rancher

sh
kubectl create namespace cattle-system

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update

helm install rancher rancher-stable/rancher \
 --namespace cattle-system \
 --set bootstrapPassword=admin \
 --set ingress.tls.source=rancher \
 --set hostname=192.168.0.195.sslip.io \
 --version 2.10.1

---

## References

- <https://kairos.io/docs/>
- <https://github.com/kairos-io/kairos/releases/>
- <https://docs.k3s.io/cli/server>
- <https://docs.k3s.io/datastore/ha>
- <https://sslip.io/>
- <https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster>
