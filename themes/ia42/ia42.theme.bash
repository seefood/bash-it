#!/usr/bin/env bash
# port of rjurgensen which is # port of zork theme
# Plus bits borrowed from powerline-multiline

. "$BASH_IT/themes/powerline-multiline/powerline-multiline.base.bash"

### Color and gliph settings
# set colors for use throughout the prompt
# I like things consistent
BRACKET_COLOR=${blue}
STRING_COLOR=${green}
PROMPT_CHAR=""
[[ $(id -u) -eq 0 ]] && PROMPT_CHAR="${bold_red}#"

USER_INFO_SSH_CHAR=${POWERLINE_USER_INFO_SSH_CHAR:=" "}
USER_INFO_THEME_PROMPT_COLOR=32
USER_INFO_THEME_PROMPT_COLOR_SUDO=202
unset GIT_THEME_PROMPT_DIRTY
unset SCM_THEME_PROMPT_SUFFIX
unset SCM_THEME_PROMPT_PREFIX
SCM_GIT_SHOW_MINIMAL_INFO=false
SCM_GIT_SHOW_DETAILS=true

PYTHON_VENV_CHAR=${POWERLINE_PYTHON_VENV_CHAR:="❲p❳ "}
CONDA_PYTHON_VENV_CHAR=${POWERLINE_CONDA_PYTHON_VENV_CHAR:="❲c❳ "}
PYTHON_VENV_THEME_PROMPT_COLOR=35

#SCM_NONE_CHAR=""
SCM_GIT_CHAR="${bold_yellow}${normal}"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓${normal}"
SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN_COLOR=25
SCM_THEME_PROMPT_DIRTY_COLOR=88
SCM_THEME_PROMPT_STAGED_COLOR=30
SCM_THEME_PROMPT_UNSTAGED_COLOR=92
SCM_THEME_PROMPT_COLOR=${SCM_THEME_PROMPT_CLEAN_COLOR}
SCM_SVN_CHAR="${bold_cyan}⑆${normal}"
SCM_HG_CHAR="${bold_red}☿${normal}"

RVM_THEME_PROMPT_PREFIX=""
RVM_THEME_PROMPT_SUFFIX=""
RBENV_THEME_PROMPT_PREFIX=""
RBENV_THEME_PROMPT_SUFFIX=""
RUBY_THEME_PROMPT_COLOR=161
RUBY_CHAR=${POWERLINE_RUBY_CHAR:="❲r❳ "}

CWD_THEME_PROMPT_COLOR=240

LAST_STATUS_THEME_PROMPT_COLOR=196

IN_VIM_THEME_PROMPT_COLOR=245
IN_VIM_THEME_PROMPT_TEXT="vim"

#POWERLINE_LEFT_PROMPT=${POWERLINE_LEFT_PROMPT:="scm python_venv ruby cwd"}
#POWERLINE_RIGHT_PROMPT=${POWERLINE_RIGHT_PROMPT:="in_vim clock battery user_info"}
POWERLINE_LEFT_PROMPT="scm python_venv ruby cwd in_vim user_info"
POWERLINE_LEFT_PROMPT="scm cwd in_vim user_info"
unset POWERLINE_RIGHT_PROMPT

#safe_append_prompt_command __powerline_prompt_command

function clientp() {
    [[ "$clientprompt" ]] && \
        echo "[${STRING_COLOR}$clientprompt${BRACKET_COLOR}]"
}

function lastret () {
    ret=$1
    [[ $ret -ne "0" ]] && \
        echo -en "${bold_red}[$ret]${BRACKET_COLOR}"
    return $ret
}

#Mysql Prompt
export MYSQL_PS1="(\u@\h) [\d]> "

PS3=">> "

__my_rvm_ruby_version() {
    local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"
    local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
    local full="$version$gemset"
  [ "$full" != "" ] && echo "${BRACKET_COLOR}[${STRING_COLOR}$full${BRACKET_COLOR}]${normal}"
}

is_vim_shell() {
    if [ ! -z "$VIMRUNTIME" ]
    then
        echo "${BRACKET_COLOR}[${STRING_COLOR}vim shell${BRACKET_COLOR}]${normal}"
    fi
}

function is_integer() { # helper function for todo-txt-count
    [ "$1" -eq "$1" ] > /dev/null 2>&1
        return $?
}

todo_txt_count() {
    if `hash todo.sh 2>&-`; then # is todo.sh installed
        count=`todo.sh ls | egrep "TODO: [0-9]+ of ([0-9]+) tasks shown" | awk '{ print $4 }'`
        if is_integer $count; then # did we get a sane answer back
            echo "${BRACKET_COLOR}[${STRING_COLOR}T:$count${BRACKET_COLOR}]$normal"
        fi
    fi
}

modern_scm_prompt() {
  CHAR=$(scm_char)
  if [ 'x$CHAR' = 'x$SCM_NONE_CHAR' ]; then
    return
  else
    echo "${BRACKET_COLOR}[${CHAR} ${STRING_COLOR}$(scm_prompt_info)${BRACKET_COLOR}]$normal"
  fi
}

prompt() {

    ret=$?

    my_ps_host="${STRING_COLOR}\h${normal}";
    my_ps_user="${STRING_COLOR}\u${normal}";
    my_ps_root="${bold_red}\u${normal}";
    my_ps_path="${STRING_COLOR}\w${normal}";

    PS1="${TITLEBAR}${BRACKET_COLOR}$(clientp)[$my_ps_root${BRACKET_COLOR}@$my_ps_host${BRACKET_COLOR}]$(modern_scm_prompt)$(__my_rvm_ruby_version)${BRACKET_COLOR}[${STRING_COLOR}\w${BRACKET_COLOR}]$(is_vim_shell)
$(lastret $ret)${PROMPT_CHAR}${normal} "

}

PS2="${PROMPT_CHAR}${normal} "



PROMPT_COMMAND=prompt
