#!/bin/bash

# Get the script directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ -z $1 ]] ; then
  echo -e "Usage: ./generate.sh 9.0.x 8.9.x 8.8.x 8.7.x 8.7.9 8.6.18"
  echo -e "List the branches and tags to test against."
  echo -e "PHP versions will be chosen automatically based on the branch."
  exit 1
fi

# @param $1
#   Version string.
function validate_version() {

  # @todo For now we only support D8 and D9.
  re="^[ ]*([8-9])\.([0-9][0-9]*)(\.(x|([0-9][0-9]*)))?[ ]*$"
  if [[ ! $1 =~ $re ]] ; then
    echo -e "Invalid branch or tag name: $1"
    exit 1
  fi
}

versions=( "$@" )
for i in "${!versions[@]}"; do
  v="${versions[$i]}"
  validate_version "$v" || ! $? -eq 0

  major_v="${BASH_REMATCH[1]}"
  minor_v="${BASH_REMATCH[2]}"
  patch_v="${BASH_REMATCH[4]}"

  if [[ $major_v = 8 ]] ; then
    if [[ $minor_v < 8 ]] ; then
      php="5.5"
    else
      php="7.1"
    fi
  else
    php="7.3"
  fi

  echo -e "Enter the one-time download ID for $v (at the end of the link):"
  read -e download

  build="$(cat $DIR/build.yml.template)"
  build="${build//__BRANCH_OR_TAG__/$v}"
  build="${build//__PHPV__/$php}"
  build="${build//__DOWNLOAD_ID__/$download}"

  echo -e "$build" > output/"$major_v""$minor_v""$patch_v".build.yml
done
