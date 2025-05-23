# Todo

- Postgresql database!

## Introduction

This setup is intended to run HA

### Prerequisuites

### Verification steps

- Shutdown one of the controlplane nodes.

## Build Kairos k3s iso image

1.  Build image:

    ```bash
    docker run -v "$PWD"/config.yaml:/config.yaml \
    -v "$PWD"/build:/tmp/auroraboot \
    --rm -ti quay.io/kairos/auroraboot \
    --set container_image=quay.io/kairos/debian:12-standard-amd64-generic-v3.4.2-k3sv1.31.7-k3s1 \
    --set "disable_http_server=true" \
    --set "disable_netboot=true" \
    --cloud-config /config.yaml \
    --set "state_dir=/tmp/auroraboot"
    ```

    > 1.31: quay.io/kairos/debian:12-standard-amd64-generic-v3.4.2-k3sv1.31.7-k3s1

2.  Ensure correct permissions are set for the build directory:

    ```bash
    sudo chown $(whoami):$(whoami) -R build
    ```

3.  Upload image to Proxmox/vSphere
