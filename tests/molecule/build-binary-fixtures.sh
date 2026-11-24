#!/bin/sh
# Builds the fake binaries the binary-install and binary-remove scenarios download, under
# /srv/fixtures/<name>/<version>/. Each fake prints its version like a real tool would, and with "serve"
# writes its version and FAKE_GREETING to /run/<name>.version, then keeps running as a service.
set -eu

ROOT=/srv/fixtures
WORK=$(mktemp -d)

# Each version gets its own file date, like real releases: unarchive tells tar.gz contents apart only by it
released() {
  case "$1" in
    1.0.0|0.20b) echo "2026-01-01 00:00" ;;
    *) echo "2026-06-01 00:00" ;;
  esac
}

# fake <file> <name> <version> <version flag> <version line> <stdout|stderr>
fake() {
  FD=1
  [ "$6" = "stderr" ] && FD=2
  mkdir -p "$(dirname "$1")"
  cat > "$1" <<EOF
#!/bin/sh
case "\${1:-}" in
  $4) echo "$5" >&${FD} ;;
  serve) echo "$3 \${FAKE_GREETING:-}" > /run/$2.version; exec sleep infinity ;;
esac
EOF
  chmod 0755 "$1"
  touch -d "$(released "$3")" "$1"
}

for V in 1.0.0 2.0.0; do
  # tar.gz with a top folder and a second file, like most GitHub releases
  D="${WORK}/fake-tar-${V}"
  fake "${D}/fake-tar" fake-tar "${V}" --version "fake-tar version v${V} (commit 1a2b3c4, go1.22.3)" stdout
  echo "not a binary" > "${D}/README.md"
  mkdir -p "${ROOT}/fake-tar/${V}"
  tar -czf "${ROOT}/fake-tar/${V}/fake-tar_linux_amd64.tar.gz" -C "${WORK}" "fake-tar-${V}"

  # Bare binaries: one printing its version on stderr, one run as a service
  fake "${ROOT}/fake-bare/${V}/fake-bare" fake-bare "${V}" --version "fake-bare ${V}" stderr
  fake "${ROOT}/fake-svc/${V}/fake-svc" fake-svc "${V}" --version "fake-svc ${V}" stdout

  # A .deb whose installer puts the binary into its own folder
  P="${WORK}/fake-pkg_${V}"
  fake "${P}/opt/fake-pkg/bin/fake-pkgd" fake-pkg "${V}" -V "Fake package agent v${V} - Copyright (C) 2026" stdout
  mkdir -p "${P}/DEBIAN"
  printf 'Package: fake-pkg\nVersion: %s\nArchitecture: all\nMaintainer: tests\nDescription: binary-install test package\n' "${V}" > "${P}/DEBIAN/control"
  mkdir -p "${ROOT}/fake-pkg/${V}"
  dpkg-deb --root-owner-group --build "${P}" "${ROOT}/fake-pkg/${V}/fake-pkg_${V}_all.deb" > /dev/null
done

# A zip holding the binary at its top level, with a letter-suffixed version printed in its help text
for V in 0.20b 0.20c; do
  D="${WORK}/fake-zip-${V}"
  fake "${D}/fake-zip" fake-zip "${V}" -h "Fake Disk Sentinel for Linux console ${V} (c) 2026
Usage: fake-zip [-h] [-r]" stdout
  mkdir -p "${ROOT}/fake-zip/${V}"
  (cd "${D}" && python3 -m zipfile -c "${ROOT}/fake-zip/${V}/fake-zip-x64.zip" fake-zip)
done

# A binary without any version information
fake "${ROOT}/fake-noversion/1.0.0/fake-noversion" fake-noversion 1.0.0 --help "usage: fake-noversion" stdout

# An installer for the user who runs it, like krew's: it puts the binary into that user's home
mkdir -p "${ROOT}/fake-uinst/1.0.0"
fake "${WORK}/fake-uinst" fake-uinst 1.0.0 --version "fake-uinst 1.0.0" stdout
{
  printf '#!/bin/sh\nset -e\nmkdir -p "${HOME}/.fake-uinst/bin"\ncat > "${HOME}/.fake-uinst/bin/fake-uinst" <<'"'"'EOF'"'"'\n'
  cat "${WORK}/fake-uinst"
  printf 'EOF\nchmod 0755 "${HOME}/.fake-uinst/bin/fake-uinst"\n'
} > "${ROOT}/fake-uinst/1.0.0/fake-uinst-install.sh"

rm -rf "${WORK}"
