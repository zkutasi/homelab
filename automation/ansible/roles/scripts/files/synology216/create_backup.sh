#!/bin/bash

SSH_USER="root"
BACKUP_ROOT="/volume1/backups/manual"
EXCLUDES=(
  "/dev/*"
  "/proc/*"
  "/sys/*"
  "/tmp/*"
  "/run/*"
  "/mnt/*"
  "/media/*"
  "/lost+found"
  "/swapfile"
  "/export/*"
  "/srv/dev-disk-by-label*"
  "/srv/dev-disk-by-uuid*"
  "/srv/mergerfs/*"
  "/var/lib/docker"
)

usage() {
  echo "Usage: $0 <vm_ip> [--user username]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

VM_IP="$1"
shift

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --user)
      SSH_USER="$2"
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done

DATE=$(date +%F)
DEST_DIR="$BACKUP_ROOT/$VM_IP-$DATE"

echo "=== Starting backup of $VM_IP on $DATE ==="
echo "SSH user: $SSH_USER"

mkdir -p "$DEST_DIR"

# Build excludes
EXCLUDE_ARGS=()
for path in "${EXCLUDES[@]}"; do
  EXCLUDE_ARGS+=(--exclude="$path")
done

# Check rsync feature support
RSYNC_OPTS="-aHv"
rsync -AXH --version >/dev/null 2>&1
if [ $? -eq 0 ]; then
  RSYNC_OPTS="-aAXHv"
fi

# Determine if remote user is root
REMOTE_UID=$(ssh -o BatchMode=yes -o StrictHostKeyChecking=no "$SSH_USER@$VM_IP" "id -u" 2>/dev/null)
if [ "$REMOTE_UID" = "0" ]; then
  echo "Remote user has root privileges — using direct rsync."
  RSYNC_PATH="rsync"
else
  echo "Remote user is non-root — using sudo rsync."
  RSYNC_PATH="sudo rsync"
fi

echo "Running backup..."
rsync $RSYNC_OPTS \
  -e "ssh -o StrictHostKeyChecking=no" \
  "${EXCLUDE_ARGS[@]}" \
  --rsync-path="$RSYNC_PATH" \
  "$SSH_USER@$VM_IP:/" "$DEST_DIR/"

if [ $? -eq 0 ]; then
  echo "Backup completed successfully for $VM_IP"
else
  echo "Backup failed for $VM_IP"
  exit 2
fi

echo "Backup stored at: $DEST_DIR"
echo "=== Backup finished ==="
