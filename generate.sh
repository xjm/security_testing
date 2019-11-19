#!/bin/bash

# Get the script directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# if [[ -z $1 ]] ; then
#   echo -e "Usage: ./generate.sh 9.0.x 8.9.x 8.8.x 8.7.x 8.7.9 8.6.18"
#   echo -e "List the branches and tags to test against."
#   echo -e "PHP versions will be chosen automatically based on the branch."
#   exit 1
# fi

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

echo "Enter the codename for the issue (e.g. 'sloth'):"
read codename

echo "Enter a list of branches or tags with the one-time download ID for each after a
space, e.g.:

9.0.x zAaTf75XE25dd45acb4a8332.68800359
8.9.x eoc2et5ays5dd45af27a9320.36838505
8.8.x nNZUwxpanJ5dd45bab4b8a48.55882353
8.8.3 QHwRAYvN4r5dd45ae27b4f34.77925831
8.7.14 DUX9hQutRF5de45b10ba42d5.15113256

Press '/' to exit the buffer.
"
read -d / download_list

echo -e "\n"

# Split the results into an array of words.
# The even indicies are the branches or tags; the odd indicies are the download
# links. So, the length of the array is 2 * the number of tests to run.
array=(${download_list// / })

declare -a versions
declare -a download_ids

for i in "${!array[@]}" ; do
    if [ "$((i % 2))" -eq 0 ] ; then
      versions[$i/2]="${array[$i]}"
    else
      download_ids[$i/2]="${array[$i]}"

  fi
done

for i in "${!versions[@]}"; do
  v="${versions[$i]}"
  validate_version "$v" || ! $? -eq 0

  major_v="${BASH_REMATCH[1]}"
  minor_v="${BASH_REMATCH[2]}"
  patch_v="${BASH_REMATCH[4]}"
  download="${download_ids[$i]}"

  if [[ $major_v = 8 ]] ; then
    if [[ $minor_v < 8 ]] ; then
      php="5.5"
    else
      php="7.1"
    fi
  else
    php="7.3"
  fi

  build="$(cat $DIR/build.yml.template)"
  build="${build//__BRANCH_OR_TAG__/$v}"
  build="${build//__PHPV__/$php}"
  build="${build//__DOWNLOAD_ID__/$download}"

  echo -e "$build" > output/"$codename""$major_v""$minor_v""$patch_v".build.yml
  echo -e "\nYour files have been created in the output/ directory.\n"
done
