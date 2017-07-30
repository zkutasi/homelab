These are scripts I have written over the time for myself, to do various small things. Some of them may be useful for somebody else, some may only be meaningful for me. Feel free to use whatever you like.

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

