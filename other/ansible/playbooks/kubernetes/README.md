# Kubernetes

KubeSpray is used to setup the cluster and install some basic tools, but there are some things that the setup is not doing.

## Usage

```bash
./run-playbook.sh --playbook playbooks/kubernetes/setup-k8s.yaml --no-check
```

## Notable comments

- The inotify kernel settings were not high enough and the root user (id 0) had already used 128 instances which is the max number per user by default. Setting this a little bit higher avoids having for example log-tailing to error with "failed to create fsnotify watcher: too many open files", or in Loki, all of the Containers logged this error too.
  - To figure this out, one great tool is the [inotify-info](https://github.com/mikesart/inotify-info), which helps you understand the limits and the actual uses. Just check out the git repo, build the tool and then copy the binary to the target host.
