PROMPT='%(!.%B%F{red}.%B%F{green}%n@)%m %B%F{blue}:: %b%F{magenta}%3~ $(hg_prompt_info)$(git_prompt_info)%B%(!.%F{red}.%F{blue})»%f%b '
RPS1='%(?..%F{red}%? ↵%f)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_HG_PROMPT_PREFIX="%{$fg_bold[magenta]%}hg:‹%{$fg_bold[yellow]%}"
ZSH_THEME_HG_PROMPT_SUFFIX="%{$fg_bold[magenta]%}› %{$reset_color%}"
ZSH_THEME_HG_PROMPT_DIRTY=" %{$fg_bold[red]%}✗"
ZSH_THEME_HG_PROMPT_CLEAN=""
