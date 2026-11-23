#!/bin/sh
# Builds the flat APT repositories the package scenarios install from, under /srv/apt:
#   signed/    fake-signed 1.0.0, InRelease signed with a key generated here (public key in key.asc)
#   plain-1/   fake-plain 1.0.0 (depends on fake-dep) and fake-extra 1.0.0, for [trusted=yes]
#   plain-2/   fake-plain 2.0.0 (no longer depends on fake-dep) and fake-extra 1.0.0
#   plain      a link to plain-1; the update scenario points it at plain-2 to publish the new versions
set -eu

ROOT=/srv/apt
WORK=$(mktemp -d)

# deb <repo folder> <package> <version> [<depends>]
deb() {
  P="${WORK}/$2_$3"
  mkdir -p "${P}/DEBIAN" "${P}/usr/share/$2"
  printf 'Package: %s\nVersion: %s\nArchitecture: all\nMaintainer: tests\n' "$2" "$3" > "${P}/DEBIAN/control"
  [ -n "${4:-}" ] && printf 'Depends: %s\n' "$4" >> "${P}/DEBIAN/control"
  printf 'Description: package role test package\n' >> "${P}/DEBIAN/control"
  echo "$3" > "${P}/usr/share/$2/version"
  mkdir -p "$1"
  dpkg-deb --root-owner-group --build "${P}" "$1/$2_$3_all.deb" > /dev/null
}

# index <repo folder>: the Packages and Release files of a flat repository
index() {
  (
    cd "$1"
    for F in *.deb; do
      dpkg-deb --field "${F}"
      printf 'Filename: ./%s\nSize: %s\nSHA256: %s\n\n' "${F}" "$(stat -c %s "${F}")" "$(sha256sum "${F}" | cut -d' ' -f1)"
    done > Packages
    printf 'Date: %s\nSHA256:\n %s %s Packages\n' "$(date -Ru)" "$(sha256sum Packages | cut -d' ' -f1)" "$(stat -c %s Packages)" > Release
  )
}

deb "${ROOT}/signed" fake-signed 1.0.0
index "${ROOT}/signed"
GNUPGHOME="${WORK}/gnupg"
export GNUPGHOME
mkdir -m 0700 "${GNUPGHOME}"
gpg --batch --quiet --passphrase "" --quick-gen-key "Package role test repository" ed25519 sign never
gpg --batch --quiet --clearsign --output "${ROOT}/signed/InRelease" "${ROOT}/signed/Release"
gpg --batch --quiet --armor --export > "${ROOT}/key.asc"

deb "${ROOT}/plain-1" fake-dep 1.0.0
deb "${ROOT}/plain-1" fake-plain 1.0.0 fake-dep
deb "${ROOT}/plain-1" fake-extra 1.0.0
index "${ROOT}/plain-1"
deb "${ROOT}/plain-2" fake-dep 1.0.0
deb "${ROOT}/plain-2" fake-plain 2.0.0
deb "${ROOT}/plain-2" fake-extra 1.0.0
index "${ROOT}/plain-2"
ln -s plain-1 "${ROOT}/plain"

rm -rf "${WORK}"
