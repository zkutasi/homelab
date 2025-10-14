from ansible.errors import AnsibleFilterError
import json

def mergerfs_paths_to_sharedfolderrefs(paths, mountpoints, sharedfolders):
    if not paths:
        return ''
    result = []
    for p in paths.split(':'):
        p = p.rstrip('/')
        for mp in mountpoints:
            if p.startswith(mp['dir']):
                subdir = p[len(mp['dir'])+1:] + '/'
                match = next(
                    (sf for sf in sharedfolders if sf['mntentref'] == mp['uuid'] and sf['reldirpath'] == subdir),
                    None
                )
                if match:
                    result.append(match['uuid'])
                break
    return result

class FilterModule(object):
    def filters(self):
        return {'mergerfs_paths_to_sharedfolderrefs': mergerfs_paths_to_sharedfolderrefs}
