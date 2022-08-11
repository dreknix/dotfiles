#
# Special shell settings template
#

# copy this file to .shell_common_local.sh

# add ~/bin-local to path
if [ -d ~/bin-local ]
then
  export PATH=${PATH}:~/bin-local
fi

# overwrite START_DIR_DIRS used in ~/bin/start-dir.sh
# export START_DIR_DIRS="$HOME/work1 $HOME/work2"

