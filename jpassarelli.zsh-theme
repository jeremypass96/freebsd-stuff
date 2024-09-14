PROMPT='%(!.%B%F{red}.%B%F{green}%n@)%m %B%F{blue}:: %B%F{yellow}%3~ $(git_prompt_info)%B%(!.%F{red}.%F{blue})»%f%b '
RPS1='%(?..%F{red}%? ↵%f)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
