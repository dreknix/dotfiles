#!/usr/bin/env bash

# use local config definition
config()
{
  /usr/bin/env git --git-dir="${HOME}/.cfg/" --work-tree="${HOME}" "$@"
}

if [ ! -d "${HOME}/dreknix" ]
then
  echo "Directory ~/dreknix does not exist"
  exit 1
fi

# check for ~/bin and updating first
if [ ! -d "${HOME}/bin" ]
then
  echo "Directory ~/bin does not exist"
  exit 1
else
  pushd "${HOME}/bin" > /dev/null || exit $?

  echo -e "\nChecking ~/bin for updates"
  changed=0
  config remote update && config status -uno | grep -q 'Your branch is behind' && changed=1
  if [ "$changed" = "1" ]
  then
    echo "Directory ~/bin is not up-to-date: 'config pull' needed first"
    exit 1
  fi

  popd > /dev/null || exit $?
fi

pushd "${HOME}/dreknix" > /dev/null || exit $?

# set cleanup function for pushd
function cleanup {
  # cd back to initial directory
  eval cd "$(dirs -0)" && dirs -c
}
trap cleanup EXIT

while IFS=";" read -r rec_type rec_dir rec_repo
do
  case "${rec_type}" in
    git)
      if [ ! -d "${rec_type}" ]
      then
        mkdir -p "${rec_type}"
      fi
      pushd "$rec_type" > /dev/null || exit $?
      echo -e "\nGit-Repository $rec_dir - $rec_repo"

      if [ -d "$rec_dir" ]
      then
        pushd "$rec_dir" > /dev/null || exit $?

        git pull --rebase

        popd > /dev/null || exit $?
      else
        git clone "$rec_repo" "$rec_dir"

        if [ -d "$rec_dir" ]
        then
          pushd "$rec_dir" > /dev/null || exit $?

          git config --local user.name "dreknix"
          git config --local user.email "dreknix@proton.me"

          popd > /dev/null || exit $?
        fi
      fi
      popd > /dev/null || exit $?
      ;;
    link)
      rec_source="${rec_dir}"
      rec_target="${rec_repo}"
      echo -e "\nLink ${rec_source} -> ${rec_target}"
      pushd "${HOME}" > /dev/null || exit $?
      if [ -e "${rec_target}" ] && [ ! -L "${rec_target}" ]
      then
        echo "Link target ${rec_target} exists and is not a link"
        exit 1
      fi

      # --relative - link that is relative to current directory (not target)
      ln --symbolic --force --no-dereference --relative --verbose "${rec_source}" "${rec_target}"
      popd > /dev/null || exit $?
      ;;
    *)
      echo "wrong entry in CSV file: $rec_type"
      ;;
  esac
done < <(grep -v '^#' "${HOME}/bin/.dreknixTree.csv" | tail +2)

popd > /dev/null || exit $?
