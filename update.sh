#!/bin/bash

set -e
if [[ " $* " =~ ' -v ' ]]; then # verbose
  set -x
fi

UPDATE_ROOT="$(cd "$(dirname "$0")"; pwd)"

unicode_emoji_url="https://www.unicode.org/Public/emoji/"
unicode_emoji_version=13.0
files=(
  "emoji-test.txt"
)
dir_temp="${UPDATE_ROOT}/temp"
file_data="emoji-data-trim.txt"
file_output="emoji_test.lua"

download_emoji_data() {
  if ! [[ -d "$dir_temp" ]]; then
    mkdir -p "$dir_temp"
  fi
  cd "$dir_temp"
  for file in ${files[@]}
  do
    curl -LO "${unicode_emoji_url}/${unicode_emoji_version}/${file}"
    # if ! [[ -f "${file}" ]]; then
    # fi
  done
}

trim_emoji_data() {
  cat ${files[@]} | grep -v "^#" | grep -v "^\s*$" | sed -e 's/.*;.*qualified[ ]*# //' -e 's/[ ].*$//' | sort -u > "${file_data}"
}

if [[ $# -eq 0 || " $* " =~ ' --download ' ]]; then
  # download
  download_emoji_data
  trim_emoji_data

  # lib
  # cd "$UPDATE_ROOT"
  # git submodule foreach --recursive git submodule init 
  # git submodule foreach --recursive git submodule update
  echo "download ok"
fi

if [[ $# -eq 0 || " $* " =~ ' --convert ' ]]; then
  # convert
  cd "$UPDATE_ROOT"
  lua_args_input="${dir_temp}/${file_data}"
  lua_args_output="${UPDATE_ROOT}/${file_output}"
  # lua convert_to_script.lua  "$lua_args_input" "${lua_args_output}"
  last_line=`cat ${lua_args_input} | wc -l`
  cat "$lua_args_input" | awk -v last_line="$last_line" '
    BEGIN {
      printf "local map_emoji = {"
    }
    {
      printf "[\"" $0 "\"]=1"
      if(NR != last_line) {
        printf ","
      }
    }
    END {
      print "}"
      print "return function(c) return map_emoji[c]==1 end"
    }' > "${lua_args_output}"

    echo "convert ok => ${lua_args_output}" 
fi

if [[ -n "`command -v lua`" ]] && [[ $# -eq 0 || " $* " =~ ' --test ' ]]; then
  # test
  module_name=`echo "${file_output}" | sed 's/[.]lua$//'`
  lua samples/test.lua "${module_name}"

  echo "test ok"
fi