# Preconfigured instances using multipass

Creates a new instance based on Ubuntu 20.04 LTS:

`multipass launch focal --name play --cpus 2 --mem 2G --disk 10G --cloud-init cloud-init-1.yaml`

`multipass launch focal --name worker1 --cpus 1 --mem 1G --disk 5G --cloud-init cloud-init-1.yaml`

`multipass launch focal --name worker2 --cpus 1 --mem 1G --disk 5G --cloud-init cloud-init-1.yaml`

`multipass launch focal --name worker3 --cpus 1 --mem 1G --disk 5G --cloud-init cloud-init-1.yaml`
