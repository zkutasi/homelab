# Rook

[Rook](https://github.com/rook/rook) makes it possible to use the Kubernetes hosts' Disk drives for network storage.

## The setup

Rook can provide the following:

- Block Storage
- Filesystem storage
- Object Storage

## Prerequisites

- Kubernetes Nodes shall have disks useful for storage.
- Rook Operator is deployed

## Usage

### Ansible inventory setup

1. Add the following variables into the `all` group_vars file:

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

2. For each Ansible host, the following variables can be set

    | Name | Mandatory/Optional | Details |
    |------|--------------------|---------|

### Deploy the Operator

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Deploy Rook

1. Install with the provided script

    ```bash
    ./deploy-k8s.sh
    ```

### Post deployment

1. Create a dashboard user via the toolbox Pod

    ```bash
    echo "<PASSWORD>" | kubectl -n rook-ceph exec -ti deployments/rook-ceph-tools -- ceph dashboard ac-user-create <USERNAME> -i /dev/stdin administrator
    ```

## Commands

### Uninstall Rook

To uninstall Rook, follow these steps

1. Uninstall the cluster

    ```bash
    helm --namespace rook-ceph uninstall rook-ceph-cluster
    ```

2. Ensure Helm resources are deleted

    ```bash
    kubectl --namespace rook-ceph delete cephobjectstore ceph-objectstore &
    kubectl --namespace rook-ceph delete cephfilesystem ceph-filesystem &
    kubectl --namespace rook-ceph delete cephblockpool ceph-blockpool &
    kubectl --namespace rook-ceph delete cephcluster rook-ceph &
    ```

3. Remove finalizers from resources

    ```bash
    kubectl --namespace rook-ceph get cephblockpools.ceph.rook.io ceph-blockpool -o json | jq '.metadata.finalizers = null' | kubectl apply -f -
    kubectl --namespace rook-ceph get cephfilesystems.ceph.rook.io ceph-filesystem -o json | jq '.metadata.finalizers = null' | kubectl apply -f -
    kubectl --namespace rook-ceph get cephobjectstores.ceph.rook.io ceph-objectstore -o json | jq '.metadata.finalizers = null' | kubectl apply -f -
    kubectl --namespace rook-ceph get cephcluster.ceph.rook.io rook-ceph -o json | jq '.metadata.finalizers = null' | kubectl apply -f -
    ```

4. Uninstall the Operator

    ```bash
    helm --namespace rook-ceph uninstall rook-ceph
    ```

5. Delete the namespace

    ```bash
    kubectl delete namespace rook-ceph
    ```

6. Remove local data from disk

    ```bash
    ansible all -i kubespray/inventory/hosts.yaml --become -a 'rm -rvf /var/lib/rook'
    ```

7. ZAP the disk to wipe it clean

    ```bash
    ansible kube_node -i kubespray/inventory/hosts.yaml --become -a 'sgdisk --zap-all /dev/sdb'
    ansible kube_node -i kubespray/inventory/hosts.yaml --become -a 'blkdiscard /dev/sdb'
    ansible kube_node -i kubespray/inventory/hosts.yaml --become -a 'partprobe /dev/sdb'
    ```

## Notable comments
