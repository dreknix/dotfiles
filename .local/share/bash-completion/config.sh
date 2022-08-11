# bash/zsh completion support for core Git.
#
# Copyright (C) 2006,2007 Shawn O. Pearce <spearce@spearce.org>
# Conceptually based on gitcompletion (http://gitweb.hawaga.org.uk/).
# Distributed under the GNU General Public License, version 2.0.
#
# The contained completion routines provide support for completing:
#
#    *) local and remote branch names
#    *) local and remote tag names
#    *) .git/remotes file names
#    *) git 'subcommands'
#    *) git email aliases for git-send-email
#    *) tree paths within 'ref:path/to/file' expressions
#    *) file paths within current working directory and index
#    *) common --long-options
#
# To use these routines:
#
#    1) Copy this file to somewhere (e.g. ~/.git-completion.bash).
#    2) Add the following line to your .bashrc/.zshrc:
#        source ~/.git-completion.bash
#    3) Consider changing your PS1 to also show the current branch,
#       see git-prompt.sh for details.
#
# If you use complex aliases of form '!f() { ... }; f', you can use the null
# command ':' as the first command in the function body to declare the desired
# completion style.  For example '!f() { : git commit ; ... }; f' will
# tell the completion to use commit completion.  This also works with aliases
# of form "!sh -c '...'".  For example, "!sh -c ': git commit ; ... '".
#
# Compatible with bash 3.2.57.
#
# You can set the following environment variables to influence the behavior of
# the completion routines:
#
#   GIT_COMPLETION_CHECKOUT_NO_GUESS
#
#     When set to "1", do not include "DWIM" suggestions in git-checkout
#     completion (e.g., completing "foo" when "origin/foo" exists).

case "$COMP_WORDBREAKS" in
*:*) : great ;;
*)   COMP_WORDBREAKS="$COMP_WORDBREAKS:"
esac

# Discovers the path to the git repository taking any '--git-dir=<path>' and
# '-C <path>' options into account and stores it in the $__config_repo_path
# variable.
__config_find_repo_path ()
{
	if [ -n "$__config_repo_path" ]; then
		# we already know where it is
		return
	fi

	if [ -n "${__config_C_args-}" ]; then
		__config_repo_path="$(config "${__config_C_args[@]}" \
			${__config_dir:+--git-dir="$__config_dir"} \
			rev-parse --absolute-git-dir 2>/dev/null)"
	elif [ -n "${__config_dir-}" ]; then
		test -d "$__config_dir" &&
		__config_repo_path="$__config_dir"
	elif [ -n "${GIT_DIR-}" ]; then
		test -d "${GIT_DIR-}" &&
		__config_repo_path="$GIT_DIR"
	elif [ -d .git ]; then
		__config_repo_path=.git
	else
		__config_repo_path="$(config rev-parse --git-dir 2>/dev/null)"
	fi
}

# Deprecated: use __config_find_repo_path() and $__config_repo_path instead
# __configdir accepts 0 or 1 arguments (i.e., location)
# returns location of .git repo
__configdir ()
{
	if [ -z "${1-}" ]; then
		__config_find_repo_path || return 1
		echo "$__config_repo_path"
	elif [ -d "$1/.git" ]; then
		echo "$1/.git"
	else
		echo "$1"
	fi
}

# Runs git with all the options given as argument, respecting any
# '--git-dir=<path>' and '-C <path>' options present on the command line
__config ()
{
	config ${__config_C_args:+"${__config_C_args[@]}"} \
		${__config_dir:+--git-dir="$__config_dir"} "$@" 2>/dev/null
}

# Removes backslash escaping, single quotes and double quotes from a word,
# stores the result in the variable $dequoted_word.
# 1: The word to dequote.
__config_dequote ()
{
	local rest="$1" len ch

	dequoted_word=""

	while test -n "$rest"; do
		len=${#dequoted_word}
		dequoted_word="$dequoted_word${rest%%[\\\'\"]*}"
		rest="${rest:$((${#dequoted_word}-$len))}"

		case "${rest:0:1}" in
		\\)
			ch="${rest:1:1}"
			case "$ch" in
			$'\n')
				;;
			*)
				dequoted_word="$dequoted_word$ch"
				;;
			esac
			rest="${rest:2}"
			;;
		\')
			rest="${rest:1}"
			len=${#dequoted_word}
			dequoted_word="$dequoted_word${rest%%\'*}"
			rest="${rest:$((${#dequoted_word}-$len+1))}"
			;;
		\")
			rest="${rest:1}"
			while test -n "$rest" ; do
				len=${#dequoted_word}
				dequoted_word="$dequoted_word${rest%%[\\\"]*}"
				rest="${rest:$((${#dequoted_word}-$len))}"
				case "${rest:0:1}" in
				\\)
					ch="${rest:1:1}"
					case "$ch" in
					\"|\\|\$|\`)
						dequoted_word="$dequoted_word$ch"
						;;
					$'\n')
						;;
					*)
						dequoted_word="$dequoted_word\\$ch"
						;;
					esac
					rest="${rest:2}"
					;;
				\")
					rest="${rest:1}"
					break
					;;
				esac
			done
			;;
		esac
	done
}

# The following function is based on code from:
#
#   bash_completion - programmable completion functions for bash 3.2+
#
#   Copyright © 2006-2008, Ian Macdonald <ian@caliban.org>
#             © 2009-2010, Bash Completion Maintainers
#                     <bash-completion-devel@lists.alioth.debian.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2, or (at your option)
#   any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, see <http://www.gnu.org/licenses/>.
#
#   The latest version of this software can be obtained here:
#
#   http://bash-completion.alioth.debian.org/
#
#   RELEASE: 2.x

# This function can be used to access a tokenized list of words
# on the command line:
#
#	__config_reassemble_comp_words_by_ref '=:'
#	if test "${words_[cword_-1]}" = -w
#	then
#		...
#	fi
#
# The argument should be a collection of characters from the list of
# word completion separators (COMP_WORDBREAKS) to treat as ordinary
# characters.
#
# This is roughly equivalent to going back in time and setting
# COMP_WORDBREAKS to exclude those characters.  The intent is to
# make option types like --date=<type> and <rev>:<path> easy to
# recognize by treating each shell word as a single token.
#
# It is best not to set COMP_WORDBREAKS directly because the value is
# shared with other completion scripts.  By the time the completion
# function gets called, COMP_WORDS has already been populated so local
# changes to COMP_WORDBREAKS have no effect.
#
# Output: words_, cword_, cur_.

__config_reassemble_comp_words_by_ref()
{
	local exclude i j first
	# Which word separators to exclude?
	exclude="${1//[^$COMP_WORDBREAKS]}"
	cword_=$COMP_CWORD
	if [ -z "$exclude" ]; then
		words_=("${COMP_WORDS[@]}")
		return
	fi
	# List of word completion separators has shrunk;
	# re-assemble words to complete.
	for ((i=0, j=0; i < ${#COMP_WORDS[@]}; i++, j++)); do
		# Append each nonempty word consisting of just
		# word separator characters to the current word.
		first=t
		while
			[ $i -gt 0 ] &&
			[ -n "${COMP_WORDS[$i]}" ] &&
			# word consists of excluded word separators
			[ "${COMP_WORDS[$i]//[^$exclude]}" = "${COMP_WORDS[$i]}" ]
		do
			# Attach to the previous token,
			# unless the previous token is the command name.
			if [ $j -ge 2 ] && [ -n "$first" ]; then
				((j--))
			fi
			first=
			words_[$j]=${words_[j]}${COMP_WORDS[i]}
			if [ $i = $COMP_CWORD ]; then
				cword_=$j
			fi
			if (($i < ${#COMP_WORDS[@]} - 1)); then
				((i++))
			else
				# Done.
				return
			fi
		done
		words_[$j]=${words_[j]}${COMP_WORDS[i]}
		if [ $i = $COMP_CWORD ]; then
			cword_=$j
		fi
	done
}

if ! type _get_comp_words_by_ref >/dev/null 2>&1; then
_get_comp_words_by_ref ()
{
	local exclude cur_ words_ cword_
	if [ "$1" = "-n" ]; then
		exclude=$2
		shift 2
	fi
	__config_reassemble_comp_words_by_ref "$exclude"
	cur_=${words_[cword_]}
	while [ $# -gt 0 ]; do
		case "$1" in
		cur)
			cur=$cur_
			;;
		prev)
			prev=${words_[$cword_-1]}
			;;
		words)
			words=("${words_[@]}")
			;;
		cword)
			cword=$cword_
			;;
		esac
		shift
	done
}
fi

# Fills the COMPREPLY array with prefiltered words without any additional
# processing.
# Callers must take care of providing only words that match the current word
# to be completed and adding any prefix and/or suffix (trailing space!), if
# necessary.
# 1: List of newline-separated matching completion words, complete with
#    prefix and suffix.
__configcomp_direct ()
{
	local IFS=$'\n'

	COMPREPLY=($1)
}

__configcompappend ()
{
	local x i=${#COMPREPLY[@]}
	for x in $1; do
		if [[ "$x" == "$3"* ]]; then
			COMPREPLY[i++]="$2$x$4"
		fi
	done
}

__configcompadd ()
{
	COMPREPLY=()
	__configcompappend "$@"
}

# Generates completion reply, appending a space to possible completion words,
# if necessary.
# It accepts 1 to 4 arguments:
# 1: List of possible completion words.
# 2: A prefix to be added to each possible completion word (optional).
# 3: Generate possible completion matches for this word (optional).
# 4: A suffix to be appended to each possible completion word (optional).
__configcomp ()
{
	local cur_="${3-$cur}"

	case "$cur_" in
	--*=)
		;;
	--no-*)
		local c i=0 IFS=$' \t\n'
		for c in $1; do
			if [[ $c == "--" ]]; then
				continue
			fi
			c="$c${4-}"
			if [[ $c == "$cur_"* ]]; then
				case $c in
				--*=*|*.) ;;
				*) c="$c " ;;
				esac
				COMPREPLY[i++]="${2-}$c"
			fi
		done
		;;
	*)
		local c i=0 IFS=$' \t\n'
		for c in $1; do
			if [[ $c == "--" ]]; then
				c="--no-...${4-}"
				if [[ $c == "$cur_"* ]]; then
					COMPREPLY[i++]="${2-}$c "
				fi
				break
			fi
			c="$c${4-}"
			if [[ $c == "$cur_"* ]]; then
				case $c in
				--*=*|*.) ;;
				*) c="$c " ;;
				esac
				COMPREPLY[i++]="${2-}$c"
			fi
		done
		;;
	esac
}

# Clear the variables caching builtins' options when (re-)sourcing
# the completion script.
if [[ -n ${ZSH_VERSION-} ]]; then
	unset $(set |sed -ne 's/^\(__configcomp_builtin_[a-zA-Z0-9_][a-zA-Z0-9_]*\)=.*/\1/p') 2>/dev/null
else
	unset $(compgen -v __configcomp_builtin_)
fi

# This function is equivalent to
#
#    __configcomp "$(git xxx --git-completion-helper) ..."
#
# except that the output is cached. Accept 1-3 arguments:
# 1: the git command to execute, this is also the cache key
# 2: extra options to be added on top (e.g. negative forms)
# 3: options to be excluded
__configcomp_builtin ()
{
	# spaces must be replaced with underscore for multi-word
	# commands, e.g. "git remote add" becomes remote_add.
	local cmd="$1"
	local incl="$2"
	local excl="$3"

	local var=__configcomp_builtin_"${cmd/-/_}"
	local options
	eval "options=\$$var"

	if [ -z "$options" ]; then
		# leading and trailing spaces are significant to make
		# option removal work correctly.
		options=" $incl $(__config ${cmd/_/ } --git-completion-helper) "
		for i in $excl; do
			options="${options/ $i / }"
		done
		eval "$var=\"$options\""
	fi

	__configcomp "$options"
}

# Variation of __configcomp_nl () that appends to the existing list of
# completion candidates, COMPREPLY.
__configcomp_nl_append ()
{
	local IFS=$'\n'
	__configcompappend "$1" "${2-}" "${3-$cur}" "${4- }"
}

# Generates completion reply from newline-separated possible completion words
# by appending a space to all of them.
# It accepts 1 to 4 arguments:
# 1: List of possible completion words, separated by a single newline.
# 2: A prefix to be added to each possible completion word (optional).
# 3: Generate possible completion matches for this word (optional).
# 4: A suffix to be appended to each possible completion word instead of
#    the default space (optional).  If specified but empty, nothing is
#    appended.
__configcomp_nl ()
{
	COMPREPLY=()
	__configcomp_nl_append "$@"
}

# Fills the COMPREPLY array with prefiltered paths without any additional
# processing.
# Callers must take care of providing only paths that match the current path
# to be completed and adding any prefix path components, if necessary.
# 1: List of newline-separated matching paths, complete with all prefix
#    path componens.
__configcomp_file_direct ()
{
	local IFS=$'\n'

	COMPREPLY=($1)

	# use a hack to enable file mode in bash < 4
	compopt -o filenames +o nospace 2>/dev/null ||
	compgen -f /non-existing-dir/ >/dev/null ||
	true
}

# Generates completion reply with compgen from newline-separated possible
# completion filenames.
# It accepts 1 to 3 arguments:
# 1: List of possible completion filenames, separated by a single newline.
# 2: A directory prefix to be added to each possible completion filename
#    (optional).
# 3: Generate possible completion matches for this word (optional).
__configcomp_file ()
{
	local IFS=$'\n'

	# XXX does not work when the directory prefix contains a tilde,
	# since tilde expansion is not applied.
	# This means that COMPREPLY will be empty and Bash default
	# completion will be used.
	__configcompadd "$1" "${2-}" "${3-$cur}" ""

	# use a hack to enable file mode in bash < 4
	compopt -o filenames +o nospace 2>/dev/null ||
	compgen -f /non-existing-dir/ >/dev/null ||
	true
}

# Execute 'git ls-files', unless the --committable option is specified, in
# which case it runs 'git diff-index' to find out the files that can be
# committed.  It return paths relative to the directory specified in the first
# argument, and using the options specified in the second argument.
__config_ls_files_helper ()
{
	if [ "$2" == "--committable" ]; then
		__config -C "$1" -c core.quotePath=false diff-index \
			--name-only --relative HEAD -- "${3//\\/\\\\}*"
	else
		# NOTE: $2 is not quoted in order to support multiple options
		__config -C "$1" -c core.quotePath=false ls-files \
			--exclude-standard $2 -- "${3//\\/\\\\}*"
	fi
}


# __config_index_files accepts 1 or 2 arguments:
# 1: Options to pass to ls-files (required).
# 2: A directory path (optional).
#    If provided, only files within the specified directory are listed.
#    Sub directories are never recursed.  Path must have a trailing
#    slash.
# 3: List only paths matching this path component (optional).
__config_index_files ()
{
	local root="$2" match="$3"

	__config_ls_files_helper "$root" "$1" "$match" |
	awk -F / -v pfx="${2//\\/\\\\}" '{
		paths[$1] = 1
	}
	END {
		for (p in paths) {
			if (substr(p, 1, 1) != "\"") {
				# No special characters, easy!
				print pfx p
				continue
			}

			# The path is quoted.
			p = dequote(p)
			if (p == "")
				continue

			# Even when a directory name itself does not contain
			# any special characters, it will still be quoted if
			# any of its (stripped) trailing path components do.
			# Because of this we may have seen the same direcory
			# both quoted and unquoted.
			if (p in paths)
				# We have seen the same directory unquoted,
				# skip it.
				continue
			else
				print pfx p
		}
	}
	function dequote(p,    bs_idx, out, esc, esc_idx, dec) {
		# Skip opening double quote.
		p = substr(p, 2)

		# Interpret backslash escape sequences.
		while ((bs_idx = index(p, "\\")) != 0) {
			out = out substr(p, 1, bs_idx - 1)
			esc = substr(p, bs_idx + 1, 1)
			p = substr(p, bs_idx + 2)

			if ((esc_idx = index("abtvfr\"\\", esc)) != 0) {
				# C-style one-character escape sequence.
				out = out substr("\a\b\t\v\f\r\"\\",
						 esc_idx, 1)
			} else if (esc == "n") {
				# Uh-oh, a newline character.
				# We cant reliably put a pathname
				# containing a newline into COMPREPLY,
				# and the newline would create a mess.
				# Skip this path.
				return ""
			} else {
				# Must be a \nnn octal value, then.
				dec = esc             * 64 + \
				      substr(p, 1, 1) * 8  + \
				      substr(p, 2, 1)
				out = out sprintf("%c", dec)
				p = substr(p, 3)
			}
		}
		# Drop closing double quote, if there is one.
		# (There isnt any if this is a directory, as it was
		# already stripped with the trailing path components.)
		if (substr(p, length(p), 1) == "\"")
			out = out substr(p, 1, length(p) - 1)
		else
			out = out p

		return out
	}'
}

# __config_complete_index_file requires 1 argument:
# 1: the options to pass to ls-file
#
# The exception is --committable, which finds the files appropriate commit.
__config_complete_index_file ()
{
	local dequoted_word pfx="" cur_

	__config_dequote "$cur"

	case "$dequoted_word" in
	?*/*)
		pfx="${dequoted_word%/*}/"
		cur_="${dequoted_word##*/}"
		;;
	*)
		cur_="$dequoted_word"
	esac

	__configcomp_file_direct "$(__config_index_files "$1" "$pfx" "$cur_")"
}

# Lists branches from the local repository.
# 1: A prefix to be added to each listed branch (optional).
# 2: List only branches matching this word (optional; list all branches if
#    unset or empty).
# 3: A suffix to be appended to each listed branch (optional).
__config_heads ()
{
	local pfx="${1-}" cur_="${2-}" sfx="${3-}"

	__config for-each-ref --format="${pfx//\%/%%}%(refname:strip=2)$sfx" \
			"refs/heads/$cur_*" "refs/heads/$cur_*/**"
}

# Lists tags from the local repository.
# Accepts the same positional parameters as __config_heads() above.
__config_tags ()
{
	local pfx="${1-}" cur_="${2-}" sfx="${3-}"

	__config for-each-ref --format="${pfx//\%/%%}%(refname:strip=2)$sfx" \
			"refs/tags/$cur_*" "refs/tags/$cur_*/**"
}

# Lists refs from the local (by default) or from a remote repository.
# It accepts 0, 1 or 2 arguments:
# 1: The remote to list refs from (optional; ignored, if set but empty).
#    Can be the name of a configured remote, a path, or a URL.
# 2: In addition to local refs, list unique branches from refs/remotes/ for
#    'git checkout's tracking DWIMery (optional; ignored, if set but empty).
# 3: A prefix to be added to each listed ref (optional).
# 4: List only refs matching this word (optional; list all refs if unset or
#    empty).
# 5: A suffix to be appended to each listed ref (optional; ignored, if set
#    but empty).
#
# Use __config_complete_refs() instead.
__config_refs ()
{
	local i hash dir track="${2-}"
	local list_refs_from=path remote="${1-}"
	local format refs
	local pfx="${3-}" cur_="${4-$cur}" sfx="${5-}"
	local match="${4-}"
	local fer_pfx="${pfx//\%/%%}" # "escape" for-each-ref format specifiers

	__config_find_repo_path
	dir="$__config_repo_path"

	if [ -z "$remote" ]; then
		if [ -z "$dir" ]; then
			return
		fi
	else
		if __config_is_configured_remote "$remote"; then
			# configured remote takes precedence over a
			# local directory with the same name
			list_refs_from=remote
		elif [ -d "$remote/.git" ]; then
			dir="$remote/.git"
		elif [ -d "$remote" ]; then
			dir="$remote"
		else
			list_refs_from=url
		fi
	fi

	if [ "$list_refs_from" = path ]; then
		if [[ "$cur_" == ^* ]]; then
			pfx="$pfx^"
			fer_pfx="$fer_pfx^"
			cur_=${cur_#^}
			match=${match#^}
		fi
		case "$cur_" in
		refs|refs/*)
			format="refname"
			refs=("$match*" "$match*/**")
			track=""
			;;
		*)
			for i in HEAD FETCH_HEAD ORIG_HEAD MERGE_HEAD REBASE_HEAD; do
				case "$i" in
				$match*)
					if [ -e "$dir/$i" ]; then
						echo "$pfx$i$sfx"
					fi
					;;
				esac
			done
			format="refname:strip=2"
			refs=("refs/tags/$match*" "refs/tags/$match*/**"
				"refs/heads/$match*" "refs/heads/$match*/**"
				"refs/remotes/$match*" "refs/remotes/$match*/**")
			;;
		esac
		__config_dir="$dir" __config for-each-ref --format="$fer_pfx%($format)$sfx" \
			"${refs[@]}"
		if [ -n "$track" ]; then
			# employ the heuristic used by git checkout
			# Try to find a remote branch that matches the completion word
			# but only output if the branch name is unique
			__config for-each-ref --format="$fer_pfx%(refname:strip=3)$sfx" \
				--sort="refname:strip=3" \
				"refs/remotes/*/$match*" "refs/remotes/*/$match*/**" | \
			uniq -u
		fi
		return
	fi
	case "$cur_" in
	refs|refs/*)
		__config ls-remote "$remote" "$match*" | \
		while read -r hash i; do
			case "$i" in
			*^{}) ;;
			*) echo "$pfx$i$sfx" ;;
			esac
		done
		;;
	*)
		if [ "$list_refs_from" = remote ]; then
			case "HEAD" in
			$match*)	echo "${pfx}HEAD$sfx" ;;
			esac
			__config for-each-ref --format="$fer_pfx%(refname:strip=3)$sfx" \
				"refs/remotes/$remote/$match*" \
				"refs/remotes/$remote/$match*/**"
		else
			local query_symref
			case "HEAD" in
			$match*)	query_symref="HEAD" ;;
			esac
			__config ls-remote "$remote" $query_symref \
				"refs/tags/$match*" "refs/heads/$match*" \
				"refs/remotes/$match*" |
			while read -r hash i; do
				case "$i" in
				*^{})	;;
				refs/*)	echo "$pfx${i#refs/*/}$sfx" ;;
				*)	echo "$pfx$i$sfx" ;;  # symbolic refs
				esac
			done
		fi
		;;
	esac
}

# Completes refs, short and long, local and remote, symbolic and pseudo.
#
# Usage: __config_complete_refs [<option>]...
# --remote=<remote>: The remote to list refs from, can be the name of a
#                    configured remote, a path, or a URL.
# --track: List unique remote branches for 'git checkout's tracking DWIMery.
# --pfx=<prefix>: A prefix to be added to each ref.
# --cur=<word>: The current ref to be completed.  Defaults to the current
#               word to be completed.
# --sfx=<suffix>: A suffix to be appended to each ref instead of the default
#                 space.
__config_complete_refs ()
{
	local remote track pfx cur_="$cur" sfx=" "

	while test $# != 0; do
		case "$1" in
		--remote=*)	remote="${1##--remote=}" ;;
		--track)	track="yes" ;;
		--pfx=*)	pfx="${1##--pfx=}" ;;
		--cur=*)	cur_="${1##--cur=}" ;;
		--sfx=*)	sfx="${1##--sfx=}" ;;
		*)		return 1 ;;
		esac
		shift
	done

	__configcomp_direct "$(__config_refs "$remote" "$track" "$pfx" "$cur_" "$sfx")"
}

# __config_refs2 requires 1 argument (to pass to __config_refs)
# Deprecated: use __config_complete_fetch_refspecs() instead.
__config_refs2 ()
{
	local i
	for i in $(__config_refs "$1"); do
		echo "$i:$i"
	done
}

# Completes refspecs for fetching from a remote repository.
# 1: The remote repository.
# 2: A prefix to be added to each listed refspec (optional).
# 3: The ref to be completed as a refspec instead of the current word to be
#    completed (optional)
# 4: A suffix to be appended to each listed refspec instead of the default
#    space (optional).
__config_complete_fetch_refspecs ()
{
	local i remote="$1" pfx="${2-}" cur_="${3-$cur}" sfx="${4- }"

	__configcomp_direct "$(
		for i in $(__config_refs "$remote" "" "" "$cur_") ; do
			echo "$pfx$i:$i$sfx"
		done
		)"
}

# __config_refs_remotes requires 1 argument (to pass to ls-remote)
__config_refs_remotes ()
{
	local i hash
	__config ls-remote "$1" 'refs/heads/*' | \
	while read -r hash i; do
		echo "$i:refs/remotes/$1/${i#refs/heads/}"
	done
}

__config_remotes ()
{
	__config_find_repo_path
	test -d "$__config_repo_path/remotes" && ls -1 "$__config_repo_path/remotes"
	__config remote
}

# Returns true if $1 matches the name of a configured remote, false otherwise.
__config_is_configured_remote ()
{
	local remote
	for remote in $(__config_remotes); do
		if [ "$remote" = "$1" ]; then
			return 0
		fi
	done
	return 1
}

__config_list_merge_strategies ()
{
	LANG=C LC_ALL=C config merge -s help 2>&1 |
	sed -n -e '/[Aa]vailable strategies are: /,/^$/{
		s/\.$//
		s/.*://
		s/^[ 	]*//
		s/[ 	]*$//
		p
	}'
}

__config_merge_strategies=
# 'git merge -s help' (and thus detection of the merge strategy
# list) fails, unfortunately, if run outside of any git working
# tree.  __config_merge_strategies is set to the empty string in
# that case, and the detection will be repeated the next time it
# is needed.
__config_compute_merge_strategies ()
{
	test -n "$__config_merge_strategies" ||
	__config_merge_strategies=$(__config_list_merge_strategies)
}

__config_complete_revlist_file ()
{
	local pfx ls ref cur_="$cur"
	case "$cur_" in
	*..?*:*)
		return
		;;
	?*:*)
		ref="${cur_%%:*}"
		cur_="${cur_#*:}"
		case "$cur_" in
		?*/*)
			pfx="${cur_%/*}"
			cur_="${cur_##*/}"
			ls="$ref:$pfx"
			pfx="$pfx/"
			;;
		*)
			ls="$ref"
			;;
		esac

		case "$COMP_WORDBREAKS" in
		*:*) : great ;;
		*)   pfx="$ref:$pfx" ;;
		esac

		__configcomp_nl "$(__config ls-tree "$ls" \
				| sed '/^100... blob /{
				           s,^.*	,,
				           s,$, ,
				       }
				       /^120000 blob /{
				           s,^.*	,,
				           s,$, ,
				       }
				       /^040000 tree /{
				           s,^.*	,,
				           s,$,/,
				       }
				       s/^.*	//')" \
			"$pfx" "$cur_" ""
		;;
	*...*)
		pfx="${cur_%...*}..."
		cur_="${cur_#*...}"
		__config_complete_refs --pfx="$pfx" --cur="$cur_"
		;;
	*..*)
		pfx="${cur_%..*}.."
		cur_="${cur_#*..}"
		__config_complete_refs --pfx="$pfx" --cur="$cur_"
		;;
	*)
		__config_complete_refs
		;;
	esac
}

__config_complete_file ()
{
	__config_complete_revlist_file
}

__config_complete_revlist ()
{
	__config_complete_revlist_file
}

__config_complete_remote_or_refspec ()
{
	local cur_="$cur" cmd="${words[1]}"
	local i c=2 remote="" pfx="" lhs=1 no_complete_refspec=0
	if [ "$cmd" = "remote" ]; then
		((c++))
	fi
	while [ $c -lt $cword ]; do
		i="${words[c]}"
		case "$i" in
		--mirror) [ "$cmd" = "push" ] && no_complete_refspec=1 ;;
		-d|--delete) [ "$cmd" = "push" ] && lhs=0 ;;
		--all)
			case "$cmd" in
			push) no_complete_refspec=1 ;;
			fetch)
				return
				;;
			*) ;;
			esac
			;;
		--multiple) no_complete_refspec=1; break ;;
		-*) ;;
		*) remote="$i"; break ;;
		esac
		((c++))
	done
	if [ -z "$remote" ]; then
		__configcomp_nl "$(__config_remotes)"
		return
	fi
	if [ $no_complete_refspec = 1 ]; then
		return
	fi
	[ "$remote" = "." ] && remote=
	case "$cur_" in
	*:*)
		case "$COMP_WORDBREAKS" in
		*:*) : great ;;
		*)   pfx="${cur_%%:*}:" ;;
		esac
		cur_="${cur_#*:}"
		lhs=0
		;;
	+*)
		pfx="+"
		cur_="${cur_#+}"
		;;
	esac
	case "$cmd" in
	fetch)
		if [ $lhs = 1 ]; then
			__config_complete_fetch_refspecs "$remote" "$pfx" "$cur_"
		else
			__config_complete_refs --pfx="$pfx" --cur="$cur_"
		fi
		;;
	pull|remote)
		if [ $lhs = 1 ]; then
			__config_complete_refs --remote="$remote" --pfx="$pfx" --cur="$cur_"
		else
			__config_complete_refs --pfx="$pfx" --cur="$cur_"
		fi
		;;
	push)
		if [ $lhs = 1 ]; then
			__config_complete_refs --pfx="$pfx" --cur="$cur_"
		else
			__config_complete_refs --remote="$remote" --pfx="$pfx" --cur="$cur_"
		fi
		;;
	esac
}

__config_complete_strategy ()
{
	__config_compute_merge_strategies
	case "$prev" in
	-s|--strategy)
		__configcomp "$__config_merge_strategies"
		return 0
	esac
	case "$cur" in
	--strategy=*)
		__configcomp "$__config_merge_strategies" "" "${cur##--strategy=}"
		return 0
		;;
	esac
	return 1
}

__config_all_commands=
__config_compute_all_commands ()
{
	test -n "$__config_all_commands" ||
	__config_all_commands=$(config --list-cmds=main,others,alias,nohelpers)
}

# Lists all set config variables starting with the given section prefix,
# with the prefix removed.
__config_get_config_variables ()
{
	local section="$1" i IFS=$'\n'
	for i in $(__config config --name-only --get-regexp "^$section\..*"); do
		echo "${i#$section.}"
	done
}

__config_pretty_aliases ()
{
	__config_get_config_variables "pretty"
}

# __config_aliased_command requires 1 argument
__config_aliased_command ()
{
	local word cmdline=$(__config config --get "alias.$1")
	for word in $cmdline; do
		case "$word" in
		\!gitk|gitk)
			echo "gitk"
			return
			;;
		\!*)	: shell command alias ;;
		-*)	: option ;;
		*=*)	: setting env ;;
		config)	: git itself ;;
		\(\))   : skip parens of shell function definition ;;
		{)	: skip start of shell helper function ;;
		:)	: skip null command ;;
		\'*)	: skip opening quote after sh -c ;;
		*)
			echo "$word"
			return
		esac
	done
}

# __config_find_on_cmdline requires 1 argument
__config_find_on_cmdline ()
{
	local word subcommand c=1
	while [ $c -lt $cword ]; do
		word="${words[c]}"
		for subcommand in $1; do
			if [ "$subcommand" = "$word" ]; then
				echo "$subcommand"
				return
			fi
		done
		((c++))
	done
}

# Echo the value of an option set on the command line or config
#
# $1: short option name
# $2: long option name including =
# $3: list of possible values
# $4: config string (optional)
#
# example:
# result="$(__config_get_option_value "-d" "--do-something=" \
#     "yes no" "core.doSomething")"
#
# result is then either empty (no option set) or "yes" or "no"
#
# __config_get_option_value requires 3 arguments
__config_get_option_value ()
{
	local c short_opt long_opt val
	local result= values config_key word

	short_opt="$1"
	long_opt="$2"
	values="$3"
	config_key="$4"

	((c = $cword - 1))
	while [ $c -ge 0 ]; do
		word="${words[c]}"
		for val in $values; do
			if [ "$short_opt$val" = "$word" ] ||
			   [ "$long_opt$val"  = "$word" ]; then
				result="$val"
				break 2
			fi
		done
		((c--))
	done

	if [ -n "$config_key" ] && [ -z "$result" ]; then
		result="$(__config config "$config_key")"
	fi

	echo "$result"
}

__config_has_doubledash ()
{
	local c=1
	while [ $c -lt $cword ]; do
		if [ "--" = "${words[c]}" ]; then
			return 0
		fi
		((c++))
	done
	return 1
}

# Try to count non option arguments passed on the command line for the
# specified git command.
# When options are used, it is necessary to use the special -- option to
# tell the implementation were non option arguments begin.
# XXX this can not be improved, since options can appear everywhere, as
# an example:
#	git mv x -n y
#
# __config_count_arguments requires 1 argument: the git command executed.
__config_count_arguments ()
{
	local word i c=0

	# Skip "git" (first argument)
	for ((i=1; i < ${#words[@]}; i++)); do
		word="${words[i]}"

		case "$word" in
			--)
				# Good; we can assume that the following are only non
				# option arguments.
				((c = 0))
				;;
			"$1")
				# Skip the specified git command and discard git
				# main options
				((c = 0))
				;;
			?*)
				((c++))
				;;
		esac
	done

	printf "%d" $c
}

__config_whitespacelist="nowarn warn error error-all fix"
__config_am_inprogress_options="--skip --continue --resolved --abort --quit --show-current-patch"

_config_am ()
{
	__config_find_repo_path
	if [ -d "$__config_repo_path"/rebase-apply ]; then
		__configcomp "$__config_am_inprogress_options"
		return
	fi
	case "$cur" in
	--whitespace=*)
		__configcomp "$__config_whitespacelist" "" "${cur##--whitespace=}"
		return
		;;
	--*)
		__configcomp_builtin am "" \
			"$__config_am_inprogress_options"
		return
	esac
}

_config_apply ()
{
	case "$cur" in
	--whitespace=*)
		__configcomp "$__config_whitespacelist" "" "${cur##--whitespace=}"
		return
		;;
	--*)
		__configcomp_builtin apply
		return
	esac
}

_config_add ()
{
	case "$cur" in
	--*)
		__configcomp_builtin add
		return
	esac

	local complete_opt="--others --modified --directory --no-empty-directory"
	if test -n "$(__config_find_on_cmdline "-u --update")"
	then
		complete_opt="--modified"
	fi
	__config_complete_index_file "$complete_opt"
}

_config_archive ()
{
	case "$cur" in
	--format=*)
		__configcomp "$(config archive --list)" "" "${cur##--format=}"
		return
		;;
	--remote=*)
		__configcomp_nl "$(__config_remotes)" "" "${cur##--remote=}"
		return
		;;
	--*)
		__configcomp "
			--format= --list --verbose
			--prefix= --remote= --exec= --output
			"
		return
		;;
	esac
	__config_complete_file
}

_config_bisect ()
{
	__config_has_doubledash && return

	local subcommands="start bad good skip reset visualize replay log run"
	local subcommand="$(__config_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__config_find_repo_path
		if [ -f "$__config_repo_path"/BISECT_START ]; then
			__configcomp "$subcommands"
		else
			__configcomp "replay start"
		fi
		return
	fi

	case "$subcommand" in
	bad|good|reset|skip|start)
		__config_complete_refs
		;;
	*)
		;;
	esac
}

_config_branch ()
{
	local i c=1 only_local_ref="n" has_r="n"

	while [ $c -lt $cword ]; do
		i="${words[c]}"
		case "$i" in
		-d|--delete|-m|--move)	only_local_ref="y" ;;
		-r|--remotes)		has_r="y" ;;
		esac
		((c++))
	done

	case "$cur" in
	--set-upstream-to=*)
		__config_complete_refs --cur="${cur##--set-upstream-to=}"
		;;
	--*)
		__configcomp_builtin branch
		;;
	*)
		if [ $only_local_ref = "y" -a $has_r = "n" ]; then
			__configcomp_direct "$(__config_heads "" "$cur" " ")"
		else
			__config_complete_refs
		fi
		;;
	esac
}

_config_bundle ()
{
	local cmd="${words[2]}"
	case "$cword" in
	2)
		__configcomp "create list-heads verify unbundle"
		;;
	3)
		# looking for a file
		;;
	*)
		case "$cmd" in
			create)
				__config_complete_revlist
			;;
		esac
		;;
	esac
}

_config_checkout ()
{
	__config_has_doubledash && return

	case "$cur" in
	--conflict=*)
		__configcomp "diff3 merge" "" "${cur##--conflict=}"
		;;
	--*)
		__configcomp_builtin checkout
		;;
	*)
		# check if --track, --no-track, or --no-guess was specified
		# if so, disable DWIM mode
		local flags="--track --no-track --no-guess" track_opt="--track"
		if [ "$GIT_COMPLETION_CHECKOUT_NO_GUESS" = "1" ] ||
		   [ -n "$(__config_find_on_cmdline "$flags")" ]; then
			track_opt=''
		fi
		__config_complete_refs $track_opt
		;;
	esac
}

__config_cherry_pick_inprogress_options="--continue --quit --abort"

_config_cherry_pick ()
{
	__config_find_repo_path
	if [ -f "$__config_repo_path"/CHERRY_PICK_HEAD ]; then
		__configcomp "$__config_cherry_pick_inprogress_options"
		return
	fi
	case "$cur" in
	--*)
		__configcomp_builtin cherry-pick "" \
			"$__config_cherry_pick_inprogress_options"
		;;
	*)
		__config_complete_refs
		;;
	esac
}

_config_clean ()
{
	case "$cur" in
	--*)
		__configcomp_builtin clean
		return
		;;
	esac

	# XXX should we check for -x option ?
	__config_complete_index_file "--others --directory"
}

_config_clone ()
{
	case "$cur" in
	--*)
		__configcomp_builtin clone
		return
		;;
	esac
}

__config_untracked_file_modes="all no normal"

_config_commit ()
{
	case "$prev" in
	-c|-C)
		__config_complete_refs
		return
		;;
	esac

	case "$cur" in
	--cleanup=*)
		__configcomp "default scissors strip verbatim whitespace
			" "" "${cur##--cleanup=}"
		return
		;;
	--reuse-message=*|--reedit-message=*|\
	--fixup=*|--squash=*)
		__config_complete_refs --cur="${cur#*=}"
		return
		;;
	--untracked-files=*)
		__configcomp "$__config_untracked_file_modes" "" "${cur##--untracked-files=}"
		return
		;;
	--*)
		__configcomp_builtin commit
		return
	esac

	if __config rev-parse --verify --quiet HEAD >/dev/null; then
		__config_complete_index_file "--committable"
	else
		# This is the first commit
		__config_complete_index_file "--cached"
	fi
}

_config_describe ()
{
	case "$cur" in
	--*)
		__configcomp_builtin describe
		return
	esac
	__config_complete_refs
}

__config_diff_algorithms="myers minimal patience histogram"

__config_diff_submodule_formats="diff log short"

__config_diff_common_options="--stat --numstat --shortstat --summary
			--patch-with-stat --name-only --name-status --color
			--no-color --color-words --no-renames --check
			--full-index --binary --abbrev --diff-filter=
			--find-copies-harder --ignore-cr-at-eol
			--text --ignore-space-at-eol --ignore-space-change
			--ignore-all-space --ignore-blank-lines --exit-code
			--quiet --ext-diff --no-ext-diff
			--no-prefix --src-prefix= --dst-prefix=
			--inter-hunk-context=
			--patience --histogram --minimal
			--raw --word-diff --word-diff-regex=
			--dirstat --dirstat= --dirstat-by-file
			--dirstat-by-file= --cumulative
			--diff-algorithm=
			--submodule --submodule= --ignore-submodules
"

_config_diff ()
{
	__config_has_doubledash && return

	case "$cur" in
	--diff-algorithm=*)
		__configcomp "$__config_diff_algorithms" "" "${cur##--diff-algorithm=}"
		return
		;;
	--submodule=*)
		__configcomp "$__config_diff_submodule_formats" "" "${cur##--submodule=}"
		return
		;;
	--*)
		__configcomp "--cached --staged --pickaxe-all --pickaxe-regex
			--base --ours --theirs --no-index
			$__config_diff_common_options
			"
		return
		;;
	esac
	__config_complete_revlist_file
}

__config_mergetools_common="diffuse diffmerge ecmerge emerge kdiff3 meld opendiff
			tkdiff vimdiff gvimdiff xxdiff araxis p4merge bc codecompare
"

_config_difftool ()
{
	__config_has_doubledash && return

	case "$cur" in
	--tool=*)
		__configcomp "$__config_mergetools_common kompare" "" "${cur##--tool=}"
		return
		;;
	--*)
		__configcomp_builtin difftool "$__config_diff_common_options
					--base --cached --ours --theirs
					--pickaxe-all --pickaxe-regex
					--relative --staged
					"
		return
		;;
	esac
	__config_complete_revlist_file
}

__config_fetch_recurse_submodules="yes on-demand no"

_config_fetch ()
{
	case "$cur" in
	--recurse-submodules=*)
		__configcomp "$__config_fetch_recurse_submodules" "" "${cur##--recurse-submodules=}"
		return
		;;
	--*)
		__configcomp_builtin fetch
		return
		;;
	esac
	__config_complete_remote_or_refspec
}

__config_format_patch_extra_options="
	--full-index --not --all --no-prefix --src-prefix=
	--dst-prefix= --notes
"

_config_format_patch ()
{
	case "$cur" in
	--thread=*)
		__configcomp "
			deep shallow
			" "" "${cur##--thread=}"
		return
		;;
	--*)
		__configcomp_builtin format-patch "$__config_format_patch_extra_options"
		return
		;;
	esac
	__config_complete_revlist
}

_config_fsck ()
{
	case "$cur" in
	--*)
		__configcomp_builtin fsck
		return
		;;
	esac
}

_config_configk ()
{
	_configk
}

# Lists matching symbol names from a tag (as in ctags) file.
# 1: List symbol names matching this word.
# 2: The tag file to list symbol names from.
# 3: A prefix to be added to each listed symbol name (optional).
# 4: A suffix to be appended to each listed symbol name (optional).
__config_match_ctag () {
	awk -v pfx="${3-}" -v sfx="${4-}" "
		/^${1//\//\\/}/ { print pfx \$1 sfx }
		" "$2"
}

# Complete symbol names from a tag file.
# Usage: __config_complete_symbol [<option>]...
# --tags=<file>: The tag file to list symbol names from instead of the
#                default "tags".
# --pfx=<prefix>: A prefix to be added to each symbol name.
# --cur=<word>: The current symbol name to be completed.  Defaults to
#               the current word to be completed.
# --sfx=<suffix>: A suffix to be appended to each symbol name instead
#                 of the default space.
__config_complete_symbol () {
	local tags=tags pfx="" cur_="${cur-}" sfx=" "

	while test $# != 0; do
		case "$1" in
		--tags=*)	tags="${1##--tags=}" ;;
		--pfx=*)	pfx="${1##--pfx=}" ;;
		--cur=*)	cur_="${1##--cur=}" ;;
		--sfx=*)	sfx="${1##--sfx=}" ;;
		*)		return 1 ;;
		esac
		shift
	done

	if test -r "$tags"; then
		__configcomp_direct "$(__config_match_ctag "$cur_" "$tags" "$pfx" "$sfx")"
	fi
}

_config_grep ()
{
	__config_has_doubledash && return

	case "$cur" in
	--*)
		__configcomp_builtin grep
		return
		;;
	esac

	case "$cword,$prev" in
	2,*|*,-*)
		__config_complete_symbol && return
		;;
	esac

	__config_complete_refs
}

_config_help ()
{
	case "$cur" in
	--*)
		__configcomp_builtin help
		return
		;;
	esac
	if test -n "$GIT_TESTING_ALL_COMMAND_LIST"
	then
		__configcomp "$GIT_TESTING_ALL_COMMAND_LIST $(config --list-cmds=alias,list-guide) gitk"
	else
		__configcomp "$(config --list-cmds=main,nohelpers,alias,list-guide) gitk"
	fi
}

_config_init ()
{
	case "$cur" in
	--shared=*)
		__configcomp "
			false true umask group all world everybody
			" "" "${cur##--shared=}"
		return
		;;
	--*)
		__configcomp_builtin init
		return
		;;
	esac
}

_config_ls_files ()
{
	case "$cur" in
	--*)
		__configcomp_builtin ls-files
		return
		;;
	esac

	# XXX ignore options like --modified and always suggest all cached
	# files.
	__config_complete_index_file "--cached"
}

_config_ls_remote ()
{
	case "$cur" in
	--*)
		__configcomp_builtin ls-remote
		return
		;;
	esac
	__configcomp_nl "$(__config_remotes)"
}

_config_ls_tree ()
{
	case "$cur" in
	--*)
		__configcomp_builtin ls-tree
		return
		;;
	esac

	__config_complete_file
}

# Options that go well for log, shortlog and gitk
__config_log_common_options="
	--not --all
	--branches --tags --remotes
	--first-parent --merges --no-merges
	--max-count=
	--max-age= --since= --after=
	--min-age= --until= --before=
	--min-parents= --max-parents=
	--no-min-parents --no-max-parents
"
# Options that go well for log and gitk (not shortlog)
__config_log_configk_options="
	--dense --sparse --full-history
	--simplify-merges --simplify-by-decoration
	--left-right --notes --no-notes
"
# Options that go well for log and shortlog (not gitk)
__config_log_shortlog_options="
	--author= --committer= --grep=
	--all-match --invert-grep
"

__config_log_pretty_formats="oneline short medium full fuller email raw format:"
__config_log_date_formats="relative iso8601 rfc2822 short local default raw"

_config_log ()
{
	__config_has_doubledash && return
	__config_find_repo_path

	local merge=""
	if [ -f "$__config_repo_path/MERGE_HEAD" ]; then
		merge="--merge"
	fi
	case "$prev,$cur" in
	-L,:*:*)
		return	# fall back to Bash filename completion
		;;
	-L,:*)
		__config_complete_symbol --cur="${cur#:}" --sfx=":"
		return
		;;
	-G,*|-S,*)
		__config_complete_symbol
		return
		;;
	esac
	case "$cur" in
	--pretty=*|--format=*)
		__configcomp "$__config_log_pretty_formats $(__config_pretty_aliases)
			" "" "${cur#*=}"
		return
		;;
	--date=*)
		__configcomp "$__config_log_date_formats" "" "${cur##--date=}"
		return
		;;
	--decorate=*)
		__configcomp "full short no" "" "${cur##--decorate=}"
		return
		;;
	--diff-algorithm=*)
		__configcomp "$__config_diff_algorithms" "" "${cur##--diff-algorithm=}"
		return
		;;
	--submodule=*)
		__configcomp "$__config_diff_submodule_formats" "" "${cur##--submodule=}"
		return
		;;
	--*)
		__configcomp "
			$__config_log_common_options
			$__config_log_shortlog_options
			$__config_log_configk_options
			--root --topo-order --date-order --reverse
			--follow --full-diff
			--abbrev-commit --abbrev=
			--relative-date --date=
			--pretty= --format= --oneline
			--show-signature
			--cherry-mark
			--cherry-pick
			--graph
			--decorate --decorate=
			--walk-reflogs
			--parents --children
			$merge
			$__config_diff_common_options
			--pickaxe-all --pickaxe-regex
			"
		return
		;;
	-L:*:*)
		return	# fall back to Bash filename completion
		;;
	-L:*)
		__config_complete_symbol --cur="${cur#-L:}" --sfx=":"
		return
		;;
	-G*)
		__config_complete_symbol --pfx="-G" --cur="${cur#-G}"
		return
		;;
	-S*)
		__config_complete_symbol --pfx="-S" --cur="${cur#-S}"
		return
		;;
	esac
	__config_complete_revlist
}

_config_merge ()
{
	__config_complete_strategy && return

	case "$cur" in
	--*)
		__configcomp_builtin merge
		return
	esac
	__config_complete_refs
}

_config_mergetool ()
{
	case "$cur" in
	--tool=*)
		__configcomp "$__config_mergetools_common tortoisemerge" "" "${cur##--tool=}"
		return
		;;
	--*)
		__configcomp "--tool= --prompt --no-prompt --gui --no-gui"
		return
		;;
	esac
}

_config_merge_base ()
{
	case "$cur" in
	--*)
		__configcomp_builtin merge-base
		return
		;;
	esac
	__config_complete_refs
}

_config_mv ()
{
	case "$cur" in
	--*)
		__configcomp_builtin mv
		return
		;;
	esac

	if [ $(__config_count_arguments "mv") -gt 0 ]; then
		# We need to show both cached and untracked files (including
		# empty directories) since this may not be the last argument.
		__config_complete_index_file "--cached --others --directory"
	else
		__config_complete_index_file "--cached"
	fi
}

_config_notes ()
{
	local subcommands='add append copy edit get-ref list merge prune remove show'
	local subcommand="$(__config_find_on_cmdline "$subcommands")"

	case "$subcommand,$cur" in
	,--*)
		__configcomp_builtin notes
		;;
	,*)
		case "$prev" in
		--ref)
			__config_complete_refs
			;;
		*)
			__configcomp "$subcommands --ref"
			;;
		esac
		;;
	*,--reuse-message=*|*,--reedit-message=*)
		__config_complete_refs --cur="${cur#*=}"
		;;
	*,--*)
		__configcomp_builtin notes_$subcommand
		;;
	prune,*|get-ref,*)
		# this command does not take a ref, do not complete it
		;;
	*)
		case "$prev" in
		-m|-F)
			;;
		*)
			__config_complete_refs
			;;
		esac
		;;
	esac
}

_config_pull ()
{
	__config_complete_strategy && return

	case "$cur" in
	--recurse-submodules=*)
		__configcomp "$__config_fetch_recurse_submodules" "" "${cur##--recurse-submodules=}"
		return
		;;
	--*)
		__configcomp_builtin pull

		return
		;;
	esac
	__config_complete_remote_or_refspec
}

__config_push_recurse_submodules="check on-demand only"

__config_complete_force_with_lease ()
{
	local cur_=$1

	case "$cur_" in
	--*=)
		;;
	*:*)
		__config_complete_refs --cur="${cur_#*:}"
		;;
	*)
		__config_complete_refs --cur="$cur_"
		;;
	esac
}

_config_push ()
{
	case "$prev" in
	--repo)
		__configcomp_nl "$(__config_remotes)"
		return
		;;
	--recurse-submodules)
		__configcomp "$__config_push_recurse_submodules"
		return
		;;
	esac
	case "$cur" in
	--repo=*)
		__configcomp_nl "$(__config_remotes)" "" "${cur##--repo=}"
		return
		;;
	--recurse-submodules=*)
		__configcomp "$__config_push_recurse_submodules" "" "${cur##--recurse-submodules=}"
		return
		;;
	--force-with-lease=*)
		__config_complete_force_with_lease "${cur##--force-with-lease=}"
		return
		;;
	--*)
		__configcomp_builtin push
		return
		;;
	esac
	__config_complete_remote_or_refspec
}

_config_range_diff ()
{
	case "$cur" in
	--*)
		__configcomp "
			--creation-factor= --no-dual-color
			$__config_diff_common_options
		"
		return
		;;
	esac
	__config_complete_revlist
}

_config_rebase ()
{
	__config_find_repo_path
	if [ -f "$__config_repo_path"/rebase-merge/interactive ]; then
		__configcomp "--continue --skip --abort --quit --edit-todo --show-current-patch"
		return
	elif [ -d "$__config_repo_path"/rebase-apply ] || \
	     [ -d "$__config_repo_path"/rebase-merge ]; then
		__configcomp "--continue --skip --abort --quit --show-current-patch"
		return
	fi
	__config_complete_strategy && return
	case "$cur" in
	--whitespace=*)
		__configcomp "$__config_whitespacelist" "" "${cur##--whitespace=}"
		return
		;;
	--*)
		__configcomp "
			--onto --merge --strategy --interactive
			--rebase-merges --preserve-merges --stat --no-stat
			--committer-date-is-author-date --ignore-date
			--ignore-whitespace --whitespace=
			--autosquash --no-autosquash
			--fork-point --no-fork-point
			--autostash --no-autostash
			--verify --no-verify
			--keep-empty --root --force-rebase --no-ff
			--rerere-autoupdate
			--exec
			"

		return
	esac
	__config_complete_refs
}

_config_reflog ()
{
	local subcommands="show delete expire"
	local subcommand="$(__config_find_on_cmdline "$subcommands")"

	if [ -z "$subcommand" ]; then
		__configcomp "$subcommands"
	else
		__config_complete_refs
	fi
}

__config_send_email_confirm_options="always never auto cc compose"
__config_send_email_suppresscc_options="author self cc bodycc sob cccmd body all"

_config_send_email ()
{
	case "$prev" in
	--to|--cc|--bcc|--from)
		__configcomp "$(__config send-email --dump-aliases)"
		return
		;;
	esac

	case "$cur" in
	--confirm=*)
		__configcomp "
			$__config_send_email_confirm_options
			" "" "${cur##--confirm=}"
		return
		;;
	--suppress-cc=*)
		__configcomp "
			$__config_send_email_suppresscc_options
			" "" "${cur##--suppress-cc=}"

		return
		;;
	--smtp-encryption=*)
		__configcomp "ssl tls" "" "${cur##--smtp-encryption=}"
		return
		;;
	--thread=*)
		__configcomp "
			deep shallow
			" "" "${cur##--thread=}"
		return
		;;
	--to=*|--cc=*|--bcc=*|--from=*)
		__configcomp "$(__config send-email --dump-aliases)" "" "${cur#--*=}"
		return
		;;
	--*)
		__configcomp_builtin send-email "--annotate --bcc --cc --cc-cmd --chain-reply-to
			--compose --confirm= --dry-run --envelope-sender
			--from --identity
			--in-reply-to --no-chain-reply-to --no-signed-off-by-cc
			--no-suppress-from --no-thread --quiet --reply-to
			--signed-off-by-cc --smtp-pass --smtp-server
			--smtp-server-port --smtp-encryption= --smtp-user
			--subject --suppress-cc= --suppress-from --thread --to
			--validate --no-validate
			$__config_format_patch_extra_options"
		return
		;;
	esac
	__config_complete_revlist
}

_config_stage ()
{
	_config_add
}

_config_status ()
{
	local complete_opt
	local untracked_state

	case "$cur" in
	--ignore-submodules=*)
		__configcomp "none untracked dirty all" "" "${cur##--ignore-submodules=}"
		return
		;;
	--untracked-files=*)
		__configcomp "$__config_untracked_file_modes" "" "${cur##--untracked-files=}"
		return
		;;
	--column=*)
		__configcomp "
			always never auto column row plain dense nodense
			" "" "${cur##--column=}"
		return
		;;
	--*)
		__configcomp_builtin status
		return
		;;
	esac

	untracked_state="$(__config_get_option_value "-u" "--untracked-files=" \
		"$__config_untracked_file_modes" "status.showUntrackedFiles")"

	case "$untracked_state" in
	no)
		# --ignored option does not matter
		complete_opt=
		;;
	all|normal|*)
		complete_opt="--cached --directory --no-empty-directory --others"

		if [ -n "$(__config_find_on_cmdline "--ignored")" ]; then
			complete_opt="$complete_opt --ignored --exclude=*"
		fi
		;;
	esac

	__config_complete_index_file "$complete_opt"
}

__config_config_get_set_variables ()
{
	local prevword word config_file= c=$cword
	while [ $c -gt 1 ]; do
		word="${words[c]}"
		case "$word" in
		--system|--global|--local|--file=*)
			config_file="$word"
			break
			;;
		-f|--file)
			config_file="$word $prevword"
			break
			;;
		esac
		prevword=$word
		c=$((--c))
	done

	__config config $config_file --name-only --list
}

__config_config_vars=
__config_compute_config_vars ()
{
	test -n "$__config_config_vars" ||
	__config_config_vars="$(config help --config-for-completion | sort | uniq)"
}

_config_config ()
{
	local varname

	if [ "${BASH_VERSINFO[0]:-0}" -ge 4 ]; then
		varname="${prev,,}"
	else
		varname="$(echo "$prev" |tr A-Z a-z)"
	fi

	case "$varname" in
	branch.*.remote|branch.*.pushremote)
		__configcomp_nl "$(__config_remotes)"
		return
		;;
	branch.*.merge)
		__config_complete_refs
		return
		;;
	branch.*.rebase)
		__configcomp "false true merges preserve interactive"
		return
		;;
	remote.pushdefault)
		__configcomp_nl "$(__config_remotes)"
		return
		;;
	remote.*.fetch)
		local remote="${prev#remote.}"
		remote="${remote%.fetch}"
		if [ -z "$cur" ]; then
			__configcomp_nl "refs/heads/" "" "" ""
			return
		fi
		__configcomp_nl "$(__config_refs_remotes "$remote")"
		return
		;;
	remote.*.push)
		local remote="${prev#remote.}"
		remote="${remote%.push}"
		__configcomp_nl "$(__config for-each-ref \
			--format='%(refname):%(refname)' refs/heads)"
		return
		;;
	pull.twohead|pull.octopus)
		__config_compute_merge_strategies
		__configcomp "$__config_merge_strategies"
		return
		;;
	color.branch|color.diff|color.interactive|\
	color.showbranch|color.status|color.ui)
		__configcomp "always never auto"
		return
		;;
	color.pager)
		__configcomp "false true"
		return
		;;
	color.*.*)
		__configcomp "
			normal black red green yellow blue magenta cyan white
			bold dim ul blink reverse
			"
		return
		;;
	diff.submodule)
		__configcomp "log short"
		return
		;;
	help.format)
		__configcomp "man info web html"
		return
		;;
	log.date)
		__configcomp "$__config_log_date_formats"
		return
		;;
	sendemail.aliasfiletype)
		__configcomp "mutt mailrc pine elm gnus"
		return
		;;
	sendemail.confirm)
		__configcomp "$__config_send_email_confirm_options"
		return
		;;
	sendemail.suppresscc)
		__configcomp "$__config_send_email_suppresscc_options"
		return
		;;
	sendemail.transferencoding)
		__configcomp "7bit 8bit quoted-printable base64"
		return
		;;
	--get|--get-all|--unset|--unset-all)
		__configcomp_nl "$(__config_config_get_set_variables)"
		return
		;;
	*.*)
		return
		;;
	esac
	case "$cur" in
	--*)
		__configcomp_builtin config
		return
		;;
	branch.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__configcomp "remote pushRemote merge mergeOptions rebase" "$pfx" "$cur_"
		return
		;;
	branch.*)
		local pfx="${cur%.*}." cur_="${cur#*.}"
		__configcomp_direct "$(__config_heads "$pfx" "$cur_" ".")"
		__configcomp_nl_append $'autoSetupMerge\nautoSetupRebase\n' "$pfx" "$cur_"
		return
		;;
	guitool.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__configcomp "
			argPrompt cmd confirm needsFile noConsole noRescan
			prompt revPrompt revUnmerged title
			" "$pfx" "$cur_"
		return
		;;
	difftool.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__configcomp "cmd path" "$pfx" "$cur_"
		return
		;;
	man.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__configcomp "cmd path" "$pfx" "$cur_"
		return
		;;
	mergetool.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__configcomp "cmd path trustExitCode" "$pfx" "$cur_"
		return
		;;
	pager.*)
		local pfx="${cur%.*}." cur_="${cur#*.}"
		__config_compute_all_commands
		__configcomp_nl "$__config_all_commands" "$pfx" "$cur_"
		return
		;;
	remote.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__configcomp "
			url proxy fetch push mirror skipDefaultUpdate
			receivepack uploadpack tagOpt pushurl
			" "$pfx" "$cur_"
		return
		;;
	remote.*)
		local pfx="${cur%.*}." cur_="${cur#*.}"
		__configcomp_nl "$(__config_remotes)" "$pfx" "$cur_" "."
		__configcomp_nl_append "pushDefault" "$pfx" "$cur_"
		return
		;;
	url.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__configcomp "insteadOf pushInsteadOf" "$pfx" "$cur_"
		return
		;;
	*.*)
		__config_compute_config_vars
		__configcomp "$__config_config_vars"
		;;
	*)
		__config_compute_config_vars
		__configcomp "$(echo "$__config_config_vars" | sed 's/\.[^ ]*/./g')"
	esac
}

_config_remote ()
{
	local subcommands="
		add rename remove set-head set-branches
		get-url set-url show prune update
		"
	local subcommand="$(__config_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		case "$cur" in
		--*)
			__configcomp_builtin remote
			;;
		*)
			__configcomp "$subcommands"
			;;
		esac
		return
	fi

	case "$subcommand,$cur" in
	add,--*)
		__configcomp_builtin remote_add
		;;
	add,*)
		;;
	set-head,--*)
		__configcomp_builtin remote_set-head
		;;
	set-branches,--*)
		__configcomp_builtin remote_set-branches
		;;
	set-head,*|set-branches,*)
		__config_complete_remote_or_refspec
		;;
	update,--*)
		__configcomp_builtin remote_update
		;;
	update,*)
		__configcomp "$(__config_remotes) $(__config_get_config_variables "remotes")"
		;;
	set-url,--*)
		__configcomp_builtin remote_set-url
		;;
	get-url,--*)
		__configcomp_builtin remote_get-url
		;;
	prune,--*)
		__configcomp_builtin remote_prune
		;;
	*)
		__configcomp_nl "$(__config_remotes)"
		;;
	esac
}

_config_replace ()
{
	case "$cur" in
	--*)
		__configcomp_builtin replace
		return
		;;
	esac
	__config_complete_refs
}

_config_rerere ()
{
	local subcommands="clear forget diff remaining status gc"
	local subcommand="$(__config_find_on_cmdline "$subcommands")"
	if test -z "$subcommand"
	then
		__configcomp "$subcommands"
		return
	fi
}

_config_reset ()
{
	__config_has_doubledash && return

	case "$cur" in
	--*)
		__configcomp_builtin reset
		return
		;;
	esac
	__config_complete_refs
}

__config_revert_inprogress_options="--continue --quit --abort"

_config_revert ()
{
	__config_find_repo_path
	if [ -f "$__config_repo_path"/REVERT_HEAD ]; then
		__configcomp "$__config_revert_inprogress_options"
		return
	fi
	case "$cur" in
	--*)
		__configcomp_builtin revert "" \
			"$__config_revert_inprogress_options"
		return
		;;
	esac
	__config_complete_refs
}

_config_rm ()
{
	case "$cur" in
	--*)
		__configcomp_builtin rm
		return
		;;
	esac

	__config_complete_index_file "--cached"
}

_config_shortlog ()
{
	__config_has_doubledash && return

	case "$cur" in
	--*)
		__configcomp "
			$__config_log_common_options
			$__config_log_shortlog_options
			--numbered --summary --email
			"
		return
		;;
	esac
	__config_complete_revlist
}

_config_show ()
{
	__config_has_doubledash && return

	case "$cur" in
	--pretty=*|--format=*)
		__configcomp "$__config_log_pretty_formats $(__config_pretty_aliases)
			" "" "${cur#*=}"
		return
		;;
	--diff-algorithm=*)
		__configcomp "$__config_diff_algorithms" "" "${cur##--diff-algorithm=}"
		return
		;;
	--submodule=*)
		__configcomp "$__config_diff_submodule_formats" "" "${cur##--submodule=}"
		return
		;;
	--*)
		__configcomp "--pretty= --format= --abbrev-commit --oneline
			--show-signature
			$__config_diff_common_options
			"
		return
		;;
	esac
	__config_complete_revlist_file
}

_config_show_branch ()
{
	case "$cur" in
	--*)
		__configcomp_builtin show-branch
		return
		;;
	esac
	__config_complete_revlist
}

_config_stash ()
{
	local save_opts='--all --keep-index --no-keep-index --quiet --patch --include-untracked'
	local subcommands='push list show apply clear drop pop create branch'
	local subcommand="$(__config_find_on_cmdline "$subcommands save")"
	if [ -n "$(__config_find_on_cmdline "-p")" ]; then
		subcommand="push"
	fi
	if [ -z "$subcommand" ]; then
		case "$cur" in
		--*)
			__configcomp "$save_opts"
			;;
		sa*)
			if [ -z "$(__config_find_on_cmdline "$save_opts")" ]; then
				__configcomp "save"
			fi
			;;
		*)
			if [ -z "$(__config_find_on_cmdline "$save_opts")" ]; then
				__configcomp "$subcommands"
			fi
			;;
		esac
	else
		case "$subcommand,$cur" in
		push,--*)
			__configcomp "$save_opts --message"
			;;
		save,--*)
			__configcomp "$save_opts"
			;;
		apply,--*|pop,--*)
			__configcomp "--index --quiet"
			;;
		drop,--*)
			__configcomp "--quiet"
			;;
		list,--*)
			__configcomp "--name-status --oneline --patch-with-stat"
			;;
		show,--*|branch,--*)
			;;
		branch,*)
			if [ $cword -eq 3 ]; then
				__config_complete_refs
			else
				__configcomp_nl "$(__config stash list \
						| sed -n -e 's/:.*//p')"
			fi
			;;
		show,*|apply,*|drop,*|pop,*)
			__configcomp_nl "$(__config stash list \
					| sed -n -e 's/:.*//p')"
			;;
		*)
			;;
		esac
	fi
}

_config_submodule ()
{
	__config_has_doubledash && return

	local subcommands="add status init deinit update summary foreach sync"
	local subcommand="$(__config_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		case "$cur" in
		--*)
			__configcomp "--quiet"
			;;
		*)
			__configcomp "$subcommands"
			;;
		esac
		return
	fi

	case "$subcommand,$cur" in
	add,--*)
		__configcomp "--branch --force --name --reference --depth"
		;;
	status,--*)
		__configcomp "--cached --recursive"
		;;
	deinit,--*)
		__configcomp "--force --all"
		;;
	update,--*)
		__configcomp "
			--init --remote --no-fetch
			--recommend-shallow --no-recommend-shallow
			--force --rebase --merge --reference --depth --recursive --jobs
		"
		;;
	summary,--*)
		__configcomp "--cached --files --summary-limit"
		;;
	foreach,--*|sync,--*)
		__configcomp "--recursive"
		;;
	*)
		;;
	esac
}

_config_svn ()
{
	local subcommands="
		init fetch clone rebase dcommit log find-rev
		set-tree commit-diff info create-ignore propget
		proplist show-ignore show-externals branch tag blame
		migrate mkdirs reset gc
		"
	local subcommand="$(__config_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__configcomp "$subcommands"
	else
		local remote_opts="--username= --config-dir= --no-auth-cache"
		local fc_opts="
			--follow-parent --authors-file= --repack=
			--no-metadata --use-svm-props --use-svnsync-props
			--log-window-size= --no-checkout --quiet
			--repack-flags --use-log-author --localtime
			--add-author-from
			--ignore-paths= --include-paths= $remote_opts
			"
		local init_opts="
			--template= --shared= --trunk= --tags=
			--branches= --stdlayout --minimize-url
			--no-metadata --use-svm-props --use-svnsync-props
			--rewrite-root= --prefix= $remote_opts
			"
		local cmt_opts="
			--edit --rmdir --find-copies-harder --copy-similarity=
			"

		case "$subcommand,$cur" in
		fetch,--*)
			__configcomp "--revision= --fetch-all $fc_opts"
			;;
		clone,--*)
			__configcomp "--revision= $fc_opts $init_opts"
			;;
		init,--*)
			__configcomp "$init_opts"
			;;
		dcommit,--*)
			__configcomp "
				--merge --strategy= --verbose --dry-run
				--fetch-all --no-rebase --commit-url
				--revision --interactive $cmt_opts $fc_opts
				"
			;;
		set-tree,--*)
			__configcomp "--stdin $cmt_opts $fc_opts"
			;;
		create-ignore,--*|propget,--*|proplist,--*|show-ignore,--*|\
		show-externals,--*|mkdirs,--*)
			__configcomp "--revision="
			;;
		log,--*)
			__configcomp "
				--limit= --revision= --verbose --incremental
				--oneline --show-commit --non-recursive
				--authors-file= --color
				"
			;;
		rebase,--*)
			__configcomp "
				--merge --verbose --strategy= --local
				--fetch-all --dry-run $fc_opts
				"
			;;
		commit-diff,--*)
			__configcomp "--message= --file= --revision= $cmt_opts"
			;;
		info,--*)
			__configcomp "--url"
			;;
		branch,--*)
			__configcomp "--dry-run --message --tag"
			;;
		tag,--*)
			__configcomp "--dry-run --message"
			;;
		blame,--*)
			__configcomp "--git-format"
			;;
		migrate,--*)
			__configcomp "
				--config-dir= --ignore-paths= --minimize
				--no-auth-cache --username=
				"
			;;
		reset,--*)
			__configcomp "--revision= --parent"
			;;
		*)
			;;
		esac
	fi
}

_config_tag ()
{
	local i c=1 f=0
	while [ $c -lt $cword ]; do
		i="${words[c]}"
		case "$i" in
		-d|--delete|-v|--verify)
			__configcomp_direct "$(__config_tags "" "$cur" " ")"
			return
			;;
		-f)
			f=1
			;;
		esac
		((c++))
	done

	case "$prev" in
	-m|-F)
		;;
	-*|tag)
		if [ $f = 1 ]; then
			__configcomp_direct "$(__config_tags "" "$cur" " ")"
		fi
		;;
	*)
		__config_complete_refs
		;;
	esac

	case "$cur" in
	--*)
		__configcomp_builtin tag
		;;
	esac
}

_config_whatchanged ()
{
	_config_log
}

_config_worktree ()
{
	local subcommands="add list lock move prune remove unlock"
	local subcommand="$(__config_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__configcomp "$subcommands"
	else
		case "$subcommand,$cur" in
		add,--*)
			__configcomp_builtin worktree_add
			;;
		list,--*)
			__configcomp_builtin worktree_list
			;;
		lock,--*)
			__configcomp_builtin worktree_lock
			;;
		prune,--*)
			__configcomp_builtin worktree_prune
			;;
		remove,--*)
			__configcomp "--force"
			;;
		*)
			;;
		esac
	fi
}

__config_complete_common () {
	local command="$1"

	case "$cur" in
	--*)
		__configcomp_builtin "$command"
		;;
	esac
}

__config_cmds_with_parseopt_helper=
__config_support_parseopt_helper () {
	test -n "$__config_cmds_with_parseopt_helper" ||
		__config_cmds_with_parseopt_helper="$(__config --list-cmds=parseopt)"

	case " $__config_cmds_with_parseopt_helper " in
	*" $1 "*)
		return 0
		;;
	*)
		return 1
		;;
	esac
}

__config_complete_command () {
	local command="$1"
	local completion_func="_config_${command//-/_}"
	if ! declare -f $completion_func >/dev/null 2>/dev/null &&
		declare -f _completion_loader >/dev/null 2>/dev/null
	then
		_completion_loader "git-$command"
	fi
	if declare -f $completion_func >/dev/null 2>/dev/null
	then
		$completion_func
		return 0
	elif __config_support_parseopt_helper "$command"
	then
		__config_complete_common "$command"
		return 0
	else
		return 1
	fi
}

__config_main ()
{
	local i c=1 command __config_dir __config_repo_path
	local __config_C_args C_args_count=0

	while [ $c -lt $cword ]; do
		i="${words[c]}"
		case "$i" in
		--git-dir=*) __config_dir="${i#--git-dir=}" ;;
		--git-dir)   ((c++)) ; __config_dir="${words[c]}" ;;
		--bare)      __config_dir="." ;;
		--help) command="help"; break ;;
		-c|--work-tree|--namespace) ((c++)) ;;
		-C)	__config_C_args[C_args_count++]=-C
			((c++))
			__config_C_args[C_args_count++]="${words[c]}"
			;;
		-*) ;;
		*) command="$i"; break ;;
		esac
		((c++))
	done

	if [ -z "$command" ]; then
		case "$prev" in
		--git-dir|-C|--work-tree)
			# these need a path argument, let's fall back to
			# Bash filename completion
			return
			;;
		-c|--namespace)
			# we don't support completing these options' arguments
			return
			;;
		esac
		case "$cur" in
		--*)   __configcomp "
			--paginate
			--no-pager
			--git-dir=
			--bare
			--version
			--exec-path
			--exec-path=
			--html-path
			--man-path
			--info-path
			--work-tree=
			--namespace=
			--no-replace-objects
			--help
			"
			;;
		*)
			if test -n "$GIT_TESTING_PORCELAIN_COMMAND_LIST"
			then
				__configcomp "$GIT_TESTING_PORCELAIN_COMMAND_LIST"
			else
				__configcomp "$(config --list-cmds=list-mainporcelain,others,nohelpers,alias,list-complete,config)"
			fi
			;;
		esac
		return
	fi

	__config_complete_command "$command" && return

	local expansion=$(__config_aliased_command "$command")
	if [ -n "$expansion" ]; then
		words[1]=$expansion
		__config_complete_command "$expansion"
	fi
}

__configk_main ()
{
	__config_has_doubledash && return

	local __config_repo_path
	__config_find_repo_path

	local merge=""
	if [ -f "$__config_repo_path/MERGE_HEAD" ]; then
		merge="--merge"
	fi
	case "$cur" in
	--*)
		__configcomp "
			$__config_log_common_options
			$__config_log_configk_options
			$merge
			"
		return
		;;
	esac
	__config_complete_revlist
}

if [[ -n ${ZSH_VERSION-} ]] &&
   # Don't define these functions when sourced from 'git-completion.zsh',
   # it has its own implementations.
   [[ -z ${GIT_SOURCING_ZSH_COMPLETION-} ]]; then
	echo "WARNING: this script is deprecated, please see git-completion.zsh" 1>&2

	autoload -U +X compinit && compinit

	__configcomp ()
	{
		emulate -L zsh

		local cur_="${3-$cur}"

		case "$cur_" in
		--*=)
			;;
		*)
			local c IFS=$' \t\n'
			local -a array
			for c in ${=1}; do
				c="$c${4-}"
				case $c in
				--*=*|*.) ;;
				*) c="$c " ;;
				esac
				array[${#array[@]}+1]="$c"
			done
			compset -P '*[=:]'
			compadd -Q -S '' -p "${2-}" -a -- array && _ret=0
			;;
		esac
	}

	__configcomp_direct ()
	{
		emulate -L zsh

		local IFS=$'\n'
		compset -P '*[=:]'
		compadd -Q -- ${=1} && _ret=0
	}

	__configcomp_nl ()
	{
		emulate -L zsh

		local IFS=$'\n'
		compset -P '*[=:]'
		compadd -Q -S "${4- }" -p "${2-}" -- ${=1} && _ret=0
	}

	__configcomp_file_direct ()
	{
		emulate -L zsh

		local IFS=$'\n'
		compset -P '*[=:]'
		compadd -Q -f -- ${=1} && _ret=0
	}

	__configcomp_file ()
	{
		emulate -L zsh

		local IFS=$'\n'
		compset -P '*[=:]'
		compadd -Q -p "${2-}" -f -- ${=1} && _ret=0
	}

	_config ()
	{
		local _ret=1 cur cword prev
		cur=${words[CURRENT]}
		prev=${words[CURRENT-1]}
		let cword=CURRENT-1
		emulate ksh -c __${service}_main
		let _ret && _default && _ret=0
		return _ret
	}

	compdef _config config
	return
fi

__config_func_wrap ()
{
	local cur words cword prev
	_get_comp_words_by_ref -n =: cur words cword prev
	$1
}

# Setup completion for certain functions defined above by setting common
# variables and workarounds.
# This is NOT a public function; use at your own risk.
__config_complete ()
{
	local wrapper="__config_wrap${2}"
	eval "$wrapper () { __config_func_wrap $2 ; }"
	complete -o bashdefault -o default -o nospace -F $wrapper $1 2>/dev/null \
		|| complete -o default -o nospace -F $wrapper $1
}

__config_complete config __config_main

