# Rook

[Rook](https://github.com/rook/rook) and the Rook Operator makes it possible to cloud-natively handle Network Storage based on the Hosts' disk drives.

## The setup

Rook can provide the following:

- Block Storage
- Filesystem storage
- Object Storage

## Prerequisites

- Kubernetes Nodes shall have disks useful for storage.

## Usage

### Deploy the app

1. Add the helm repository

    ```bash
    helm repo add rook-release https://charts.rook.io/release
    helm repo update
    ```

2. Check which version you want to install, or leave empty to take the latest available version

    ```bash
    helm search repo rook-release/rook-ceph -l
    ```

3. Create a values yaml file for potential private data named `app-values-private.yaml`

4. Install with the provided script

    ```bash
    ./deploy-k8s.sh
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
