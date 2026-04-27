#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts curl jq git gnused gnugrep libplist undmg
set -euo pipefail


# executing this script without arguments will
# - find the newest stable spotify version available on snapcraft (https://snapcraft.io/spotify)
# - read the current spotify version from the current nix expression
# - update the nix expression if the versions differ
# - try to build the updated version, exit if that fails
# - give instructions for upstreaming

# Please test the update manually before pushing. There have been errors before
# and because the service is proprietary and a paid account is necessary to do
# anything with spotify automatic testing is not possible.

# As an optional argument you can specify the snapcraft channel to update to.
# Default is `stable` and only stable updates should be pushed to nixpkgs. For
# testing you may specify `candidate` or `edge`.


channel="${1:-edge}" # stable/candidate/edge
nix_config="$(git rev-parse --show-toplevel)"

update_linux() {
  nix_file="$nix_config/pkgs/spotify/linux.nix"
  #
  # find the newest stable spotify version available on snapcraft
  #

  # create bash array from snap info
  snap_info=($(
    curl -s -H 'X-Ubuntu-Series: 16' \
      "https://api.snapcraft.io/api/v1/snaps/details/spotify?channel=$channel" \
    | jq --raw-output \
      '.revision,.download_sha512,.version,.last_updated'
  ))

  # "revision" is the actual version identifier on snapcraft, the "version" is
  # just for human consumption. Revision is just an integer that gets increased
  # by one every (stable or unstable) release.
  revision="${snap_info[0]}"
  # We need to escape the slashes
  hash="$(nix-hash --to-sri --type sha512 ${snap_info[1]} | sed 's|/|\\/|g')"
  upstream_version="${snap_info[2]}"
  last_updated="${snap_info[3]}"
  echo "Latest $channel release for Spotify on Linux is $upstream_version from $last_updated."
  #
  # read the current spotify version from the currently *committed* nix expression
  #

  current_nix_version=$(
    grep 'version\s*=' "$nix_file" \
    | sed -Ene 's/.*"(.*)".*/\1/p'
  )

  echo "Current Spotify for Linux version in Nixpkgs: $current_nix_version"

  #
  # update the nix expression if the versions differ
  #

  if [[ "$current_nix_version" = "$upstream_version" ]]; then
    echo "Spotify on Linux is already up-to-date"
    return
  fi

  echo "Updating Spotify on Linux from ${current_nix_version} to ${upstream_version}, released on ${last_updated}"

  # search-and-replace revision, hash and version
  sed --regexp-extended \
    -e 's/rev\s*=\s*"[0-9]+"\s*;/rev = "'"${revision}"'";/' \
    -e 's/hash\s*=\s*"[^"]*"\s*;/hash = "'"${hash}"'";/' \
    -e 's/version\s*=\s*".*"\s*;/version = "'"${upstream_version}"'";/' \
    -i "$nix_file"
}

update_linux
