# vim:ft=zsh ts=2 sw=2 sts=2

# Virtualenv Python
venv_prompt_info() {
  [[ -z $VIRTUAL_ENV ]] && return
  local name=${VIRTUAL_ENV_PROMPT:-${VIRTUAL_ENV:t}}
  name=${name//[() ]/}   # strip parentheses/spaces depending on venv/uv version
  echo "%{$fg[magenta]%}🐍 ${name}%{$reset_color%}"
}

# Default color
master_color='white'

# If user is root
# │ or ├─
if [ $UID -eq 0 ]
then
  arrow0='%{$fg[red]%}╭─%{$fg[${master_color}]%}'
  arrow1='%{$fg[red]%}├─'
  arrow2='%{$fg[red]%}╰─➤'
else
  arrow0='%{$fg[${master_color}]%}╭─'
  arrow1='%{$fg[${master_color}]%}├─'
  arrow2='%{$fg[${master_color}]%}╰─➤'
fi

# Var prompt user han host info
ps0_fe80="${arrow0}%n@%m %{$fg[yellow]%}"
ps1_fe80="${arrow1}%{$reset_color%}"
ps2_fe80="${arrow2}%{$reset_color%}"

# Git info
# Call the sync version: the async git_prompt_info is only fed when
# `$(git_prompt_info)` appears literally in $PROMPT, and the layout needs it now
git_ninfo() {
  local info
  if (( $+functions[_omz_git_prompt_info] )); then
    info="$(_omz_git_prompt_info)"
  else
    info="$(git_prompt_info)"
  fi
  echo -n "${info}$(git_remote_status)"
}

# Return code if is not 0
return_code="%(?..%{$fg[red]%} %? ↵%{$reset_color%})"

# Hour
hour="%{$FG[248]%}[%*]%{$reset_color%}"

# Kub theme
KUBE_PS1_PREFIX=''
KUBE_PS1_SYMBOL_ENABLE=true
KUBE_PS1_SEPARATOR=' '
KUBE_PS1_CTX_COLOR='blue'
KUBE_PS1_SUFFIX=''
KUBE_PS1_NS_ENABLE=false
KUBE_PS1_BINARY=$(which kubectl)
VIRTUAL_ENV_DISABLE_PROMPT=1
kub_ninfo() { (( $+functions[kube_ps1] )) && kube_ps1 }

# Info functions shown in the prompt (in order)
args_ninfo=(kub_ninfo git_ninfo venv_prompt_info)

# Build the prompt before each display:
# - third ├─ line with the infos only if there are >= 3 non-empty infos,
#   or if the path is longer than half the terminal width
# - path shortened with `..` when it reaches 75% of the terminal width
_fe80_build_prompt() {
  local fn out
  local -a infos
  for fn in $args_ninfo; do
    out="$($fn 2>/dev/null)"
    out=${out%"${out##*[^[:space:]]}"}   # trim trailing spaces (e.g. git suffix)
    [[ -n $out ]] && infos+=("$out")
  done
  _fe80_infos="${(j: :)infos}"

  local path_len=${(m)#${(%):-%~}}
  local max_len=$(( COLUMNS * 3 / 4 ))
  if (( path_len >= max_len )); then
    _fe80_path="%${max_len}<..<%~%<<"
  else
    _fe80_path="%~"
  fi

  if (( ${#infos} >= 3 || path_len * 2 > COLUMNS )); then
    PROMPT="${ps0_fe80}"'${_fe80_path}'"%{$reset_color%}
${ps1_fe80} "'${_fe80_infos}'"
${ps2_fe80} "
  elif (( ${#infos} )); then
    PROMPT="${ps0_fe80}"'${_fe80_path}'"%{$reset_color%} "'${_fe80_infos}'"
${ps2_fe80} "
  else
    PROMPT="${ps0_fe80}"'${_fe80_path}'"%{$reset_color%}
${ps2_fe80} "
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _fe80_build_prompt
_fe80_build_prompt

PROMPT2="${ps2_fe80} "

# Right prompt
RPROMPT="%{$(echotc UP 1)%}${hour}${return_code}%{$(echotc DO 1)%}"

# Git theme
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$FG[136]%}↑%{$reset_color%}"
