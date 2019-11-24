# Scripts by Zoltan Kutasi

These are scripts I have written over the time for myself, to do various small things. Some of them may be useful for somebody else, some may only be meaningful for me. Feel free to use whatever you like.

## Getting Started

Most of these scripts are based on an Ansible distribution system, so they sometimes contain Jinja template variables, and named ...j2. This ensures that I can reuse the same scripts on multiple machines, even if those machines have different distros or architectures. Also this makes it possible to develop them in a single place, then deploy them to the target machines without getting crazy. Ansible is a very powerful tool in helping manage remote machines using no more than SSH and python.

A lot of the scripts are built around the pushover service, which is a push notification service anyone can use to get any kind of push notices, as you can see I have numerous little messages prepared:
- Notify with a push if a torrent on my seed server is downloaded, also notify me about the free space, so I can get in if it gets low
- Notify me about failed login attempts
- Notify me about successful login attempts
- Notify me if a server has pending software upgrades
- Notify me about my monthly traffic, specifically for the last 24 hours, per host (so I can fine-tune the quotas/traffic/bandwidth)

Also there are other things
- Manage deluge with systemd, and let me know if it stopped/started
- A custom media-summarizer, to check which HDD has how many stuff of what kind
- Check files in directories against a running Deluge daemon and saee if they are added or not

### Prerequisites

You can reuse any of the scripts, after you remove the jinja templating from them, OR you can of course use Ansible to manage your scripts and machines. No additional prerequisite is there to know, other than of course most of the scripts need to be parameterized a bit to work in your environment. Usually this can be done by reading the first few lines, and filling in some variables.

### Installing

Let us assume, you will try to use Ansible, so how to do it?

1. Install Ansible on a control machine
2. Create an Ansible inventory with your hosts
3. Fill host_vars and group_vars to set up variables in the playbook roles
4. Use ansible-vault to encrypt these files, since most probably you will need passwords in them
5. Now it is a good time to test the connections with the ping module of Ansible
6. Rewrite the existing playbook setup.yml, or create your own
7. Use ansible-playbook to execute the script-pushing to the right machines to the right places, without having a single concern whether you miss something or not.

## Running the tests

Hahaha, no tests were written, these are scripts with a maximum of a few hundred lines.

## Deployment

Some scripts have to be deployed into specific directories, that could be different depending on distro or installation parameters. Always check every script if it has the correct end-destination.

## Built With

No, these are just scripts and descriptor files, no building was necessary.

## Versioning

No.

## Authors

Me.

## License

Do whatever you like with these, I do not care. I have done these for myself.

## Acknowledgements

My congratulations go to the people out there who inspired me with Wikis, Blog-posts or whole articles about what to do and how to do it.
