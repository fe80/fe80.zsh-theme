# vim:ft=zsh ts=2 sw=2 sts=2

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
master_color='white'
ps1_steffy="%{$fg[${master_color}]%}╭─%n@%m %{$fg[yellow]%}%~"
git_ninfo='$(git_prompt_info)'
ps2_steffy="%{$fg[${master_color}]%}╰─➤%{$reset_color%}%"
return_code="%(?..%{$fg[red]%} %? ↵%{$reset_color%})"
hour="%{$FG[248]%}[%*]%{$reset_color%}"

PROMPT="${ps1_steffy} ${git_ninfo}
${ps2_steffy}\ "
PROMPT2="${ps2_steffy}\ "
RPROMPT="%{$(echotc UP 1)%}${hour}${return_code}%{$(echotc DO 1)%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
