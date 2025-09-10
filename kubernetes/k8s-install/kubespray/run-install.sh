pushd kubespray-repo
ansible-playbook -i ../inventory/hosts.yaml cluster.yml --become
popd
