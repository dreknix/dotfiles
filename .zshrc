# use https://github.com/jandedobbeleer/oh-my-posh
OHMYPOSH_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}/oh-my-posh"
eval "$(posh init zsh --config ${OHMYPOSH_HOME}/dreknix.omp.yaml)"

# use https://github.com/zdharma-continuum/zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "${ZINIT_HOME}" ]
then
  mkdir -p "$(dirname ${ZINIT_HOME})"
  if [ ! -d "${ZINIT_HOME}/.git" ]
  then
    git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
  fi
fi
source "${ZINIT_HOME}/zinit.zsh"
