pushd kubespray-repo
ansible -i ../inventory/hosts.yaml -m ping all
popd
