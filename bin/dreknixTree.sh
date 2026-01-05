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
  config remote update > /dev/null 2>&1 && \
    config status -uno 2> /dev/null | grep -q 'Your branch is behind' && changed=1
  if [ "$changed" = "1" ]
  then
    tput setaf 0
    echo "Directory ~/bin is not up-to-date: 'config pull' needed first"
    tput sgr0
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

function print_msg {
  tput setaf "$1"; echo -en "$2"; tput sgr0
}

repositories=()
repositories_status=()

while IFS=";" read -r rec_type rec_dir rec_repo
do
  case "${rec_type}" in
    git)
      repositories+=("$rec_repo")
      echo -e "\nGit-Repository $rec_dir - $rec_repo"

      if [ -d "$rec_dir" ]
      then
        pushd "$rec_dir" > /dev/null || exit $?

        if git remote update > /dev/null 2>&1
        then
          if git status -uno 2> /dev/null | grep -q 'Your branch is up to date with'
          then
            repositories_status+=("$(print_msg 2 "ok")")
          else
            if git pull --rebase
            then
              repositories_status+=("$(print_msg 3 "changed")")
            else
              repositories_status+=("$(print_msg 9 "error")")
            fi
          fi
        else
          repositories_status+=("$(print_msg 9 "error")")
        fi

        popd > /dev/null || exit $?
      else
        if git clone "$rec_repo" "$rec_dir"
        then
          repositories_status+=("$(print_msg 5 "cloned")")
        else
          repositories_status+=("$(print_msg 9 "error")")
        fi

        if [ -d "$rec_dir" ]
        then
          pushd "$rec_dir" > /dev/null || exit $?

          git config --local user.name "dreknix"
          git config --local user.email "dreknix@proton.me"

          popd > /dev/null || exit $?
        fi
      fi
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
done < <(grep -v '^#' "${HOME}/bin/.dreknixTree.csv" | tail -n +2)

popd > /dev/null || exit $?

print_msg 6 "\nList of repositories:\n"
index=0
for repository in ${repositories[@]}
do
  printf "%-60s %s\n" "${repository}:" "${repositories_status[$index]}"
  index=$((index + 1))
done
