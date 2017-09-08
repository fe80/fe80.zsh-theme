# vim:ft=zsh ts=2 sw=2 sts=2

# Default color
master_color='white'

# If user is root
if [ $UID -eq 0 ]; then
  arrow0='%{$fg[red]%}╭─%{$fg[${master_color}]%}'
  arrow1='%{$fg[red]%}╰─➤'
else
  arrow0='%{$fg[${master_color}]%}╭─'
  arrow1='%{$fg[${master_color}]%}╰─➤'
fi

# If Cloud
if [ $ZSHCLOUD ]; then
  $_cloud='%{$fg[green]%}☁ '
else
  $_cloud=''
end

# Var prompt user han host info
ps0_fe80="${arrow0}%n@%m ${_cloud}%{$fg[yellow]%}%~"
ps1_fe80="${arrow1}%{$reset_color%}%"

# Git info
git_ninfo='$(git_prompt_info)$(git_remote_status)'

# Return code if is not 0
return_code="%(?..%{$fg[red]%} %? ↵%{$reset_color%})"

# Hour
hour="%{$FG[248]%}[%*]%{$reset_color%}"

# Prompt
PROMPT="${ps0_fe80} ${git_ninfo}
${ps1_fe80}\ "
PROMPT2="${ps1_fe80}\ "

# Right prompt
RPROMPT="%{$(echotc UP 1)%}${hour}${return_code}%{$(echotc DO 1)%}"

# Git theme
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$FG[136]%}↑%{$reset_color%}"
