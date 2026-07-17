PROMPT=' %{%F{22}%}$(get_pwd)%{$reset_color%} $(git_prompt_info)${prompt_suffix}'

local return_status="%(?:%{%F{202}%}π:%{$fg_bold[red]%}π)"

local prompt_suffix="%{$fg_bold[green]%}❯%{$reset_color%} "

# by shashankmehta (https://github.com/shashankmehta)
function get_pwd(){
  git_root=$PWD
  while [[ $git_root != / && ! -e $git_root/.git ]]; do
    git_root=$git_root:h
  done
  if [[ $git_root = / ]]; then
    unset git_root
    prompt_short_dir=%~
  else
    parent=${git_root%\/*}
    prompt_short_dir=${PWD#$parent/}
  fi
  echo $prompt_short_dir
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{%F{202}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""
