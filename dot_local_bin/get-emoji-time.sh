#!/bin/bash

get_time_emoji() {
  local hour=$(date +"%I")
  local minute=$(date +"%M")
  local emoji
  if [ "$minute" -ge 30 ]; then
    case $hour in
      12) emoji="🕧";;
      01) emoji="🕜";;
      02) emoji="🕝";;
      03) emoji="🕞";;
      04) emoji="🕟";;
      05) emoji="🕠";;
      06) emoji="🕡";;
      07) emoji="🕢";;
      08) emoji="🕣";;
      09) emoji="🕤";;
      10) emoji="🕥";;
      11) emoji="🕦";;
    esac
  else
    case $hour in
      12) emoji="🕛";;
      01) emoji="🕐";;
      02) emoji="🕑";;
      03) emoji="🕒";;
      04) emoji="🕓";;
      05) emoji="🕔";;
      06) emoji="🕕";;
      07) emoji="🕖";;
      08) emoji="🕗";;
      09) emoji="🕘";;
      10) emoji="🕙";;
      11) emoji="🕚";;
    esac
  fi

  echo $emoji
}

# Test the function
get_time_emoji
