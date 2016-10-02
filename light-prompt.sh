#!/bin/bash

# COLORS
PURPLE_BG=("\[\033[48;5;54m\]" "\[\033[48;5;90m\]" "\[\033[48;5;126m\]" "\[\033[48;5;162m\]" "\[\033[48;5;198m\]")
PURPLE_FG=("\[\033[38;5;54m\]" "\[\033[38;5;90m\]" "\[\033[38;5;126m\]" "\[\033[38;5;162m\]" "\[\033[38;5;198m\]")

COLOR_BG_DARK="\[$(tput setab 0)\]"
COLOR_BG_GREY="\[\033[0;47m\]"
COLOR_BG_RED="\[$(tput setab 1)\]"
COLOR_BG_BLUE="\[$(tput setab 4)\]"
COLOR_BG_GREEN="\[$(tput setab 2)\]"
#COLORS_BG=( $COLOR_BG_DARK $COLOR_BG_RED $COLOR_BG_BLUE $COLOR_BG_GREEN $COLOR_BG_GREY )
COLORS_BG=(${PURPLE_BG[*]})

COLOR_FG_DARK="\[$(tput setaf 0)\]"
COLOR_FG_GREY="\[\033[0;37m\]"
COLOR_FG_RED="\[$(tput setaf 1)\]"
COLOR_FG_BLUE="\[$(tput setaf 4)\]"
COLOR_FG_GREEN="\[$(tput setaf 2)\]"
#COLORS_FG=( $COLOR_FG_DARK $COLOR_FG_RED $COLOR_FG_BLUE $COLOR_FG_GREEN $COLOR_FG_GREY )
COLORS_FG=(${PURPLE_FG[*]})

RESET="\[$(tput sgr0)\]"

# SYMBOLS
SEP=""
GIT_MAIN="⎇"

# Functions

get_dir(){
  echo "\W"
}

get_hostname(){
  echo "\h"
}

get_git(){
  if [ ! -x "$(which git)" ]
  then
    echo ""
    return
  fi

  local git_eng="env LANG=C git"   # force git output in English to make our work easier
  # get current branch name or short SHA1 hash for detached head
  local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

  if [[ ! $branch ]]
  then
    echo ""
    return  # git branch not found
  fi
  echo "$GIT_MAIN  $branch"
}

ps1(){
  PS1=""

  local command_list=( "get_hostname" "get_dir" "get_git")
  local info_list=()
  local list_size=$((${#command_list[*]}-1))

  for i in $(seq 0 $list_size)
  do
    local get_res=${command_list[$i]}
    local get_command=$($get_res)

    if [[ $get_command = *[!\ ]* ]]
    then
      info_list+=("${get_command}")
    fi
  done
  #echo ${info_list[*]}
  list_size=$((${#info_list[*]}-1))
  for i in $(seq 0 $list_size)
  do
    if [[ $i == $list_size ]]
    then
      SEP_COLOR="$RESET${COLORS_FG[$i]}$SEP"
      PS1+="${COLORS_BG[$i]} ${info_list[$i]} $SEP_COLOR$RESET "
    else
      SEP_COLOR="${COLORS_BG[$(($i+1))]}${COLORS_FG[$i]}$SEP"
      PS1+="${COLORS_BG[$i]} ${info_list[$i]} $SEP_COLOR$RESET"
    fi
  done
}

PROMPT_COMMAND=ps1
#ps1
