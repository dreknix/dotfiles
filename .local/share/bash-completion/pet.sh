#!/bin/bash

_pet_commands="activate configure edit editenv exec help list listenv new newenv search sync version"

_pet_completions()
{
  if [ "${#COMP_WORDS[@]}" == "2" ]
  then
    #echo "2 ${#COMP_WORDS[@]}"
    COMPREPLY=($(compgen -W "${_pet_commands}" -- "${COMP_WORDS[COMP_CWORD]}"))
  fi
  if [ "${#COMP_WORDS[@]}" -ge "3" ]
  then
    #echo "3 ${#COMP_WORDS[@]}"
    case "${COMP_WORDS[1]}" in
      exec)
        COMPREPLY=($(compgen -W "-c --command -h --help -d --delimeter -q --query -t --tag" -- "${COMP_WORDS[COMP_CWORD]}"))
        ;;
      search)
        COMPREPLY=($(compgen -W "-h --help -d --delimeter -q --query -t --tag" -- "${COMP_WORDS[COMP_CWORD]}"))
        ;;
      new)
        COMPREPLY=($(compgen -W "-h --help -t --tag" -- "${COMP_WORDS[COMP_CWORD]}"))
        ;;
      *)
        COMPREPLY=($(compgen -W "-h --help" -- "${COMP_WORDS[COMP_CWORD]}"))
        ;;
    esac
  fi
  #echo ""
  #echo "${COMP_WORDS[0]}"
  #echo "${COMP_WORDS[1]}"
}
complete -F _pet_completions pet
