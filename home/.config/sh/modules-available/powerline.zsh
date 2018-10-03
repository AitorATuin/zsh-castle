local _POWERLINE_SOURCED="$0:A"

_powerline_columns_fallback() {
	if which stty &>/dev/null ; then
		local cols="$(stty size 2>/dev/null)"
		if ! test -z "$cols" ; then
			echo "${cols#* }"
			return 0
		fi
	fi
	echo 0
	return 0
}

integer -g _POWERLINE_JOBNUM=0

_powerline_tmux_pane() {
	local -x TMUX="$_POWERLINE_TMUX"
	echo "${TMUX_PANE:-`tmux display -p "#D"`}" | tr -d ' %'
}

_powerline_init_tmux_support() {
	emulate -L zsh
	if test -n "$TMUX" && tmux refresh -S &>/dev/null ; then
		# TMUX variable may be unset to create new tmux session inside this one
		typeset -g _POWERLINE_TMUX="$TMUX"

		function -g _powerline_tmux_setenv() {
			emulate -L zsh
			local -x TMUX="$_POWERLINE_TMUX"
			tmux setenv -g TMUX_"$1"_$(_powerline_tmux_pane) "$2"
			tmux refresh -S
		}

		function -g _powerline_tmux_set_pwd() {
			_powerline_tmux_setenv PWD "$PWD"
		}

		function -g _powerline_tmux_set_columns() {
			_powerline_tmux_setenv COLUMNS "${COLUMNS:-$(_powerline_columns_fallback)}"
		}

		chpwd_functions+=( _powerline_tmux_set_pwd )
		trap '_powerline_tmux_set_columns' SIGWINCH
		_powerline_tmux_set_columns
		_powerline_tmux_set_pwd
	fi
}

if test -z "${POWERLINE_CONFIG_COMMAND}" ; then
	if which powerline-config >/dev/null ; then
		typeset -g POWERLINE_CONFIG_COMMAND=powerline-config
	else
		typeset -g POWERLINE_CONFIG_COMMAND="${_POWERLINE_SOURCED:h:h:h:h}/scripts/powerline-config"
	fi
fi

if "${POWERLINE_CONFIG_COMMAND}" shell --shell=zsh uses tmux ; then
	_powerline_init_tmux_support
fi
