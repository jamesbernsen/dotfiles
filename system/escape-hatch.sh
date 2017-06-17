#!/usr/bin/env bash

# Prints a short countdown that can be interrupted by a keypress.
# Arguments:
#    $1 - number of seconds from which to count down
#    $2 - character keypress that will escape the sequence (if this argument
#         is not given, then any character will cause the escape

# Credit:
# https://stackoverflow.com/questions/9731281/bash-script-listen-for-key-press-to-move-on
# https://stackoverflow.com/questions/29720579/counting-down-in-a-loop-to-zero-by-the-number-being-given

# Include dotfiles functions
. ~/dotfiles/system/function.sh

# Enable extended globs
shopt -s extglob

if (( $# < 1 )); then
  printf >&2 'Numeric timeout argument required\n'
  exit 3
elif [[ $1 != +([0-9]) || $1 -eq 0 ]]; then
  printf >&2 'Timeout must be a positive integer\n'
  exit 4
fi
timeout=$1

if (( $# > 1 )); then
  esc_char=$2
fi

# Need Bash 4 to use fractional time with read -t
if [[ "${BASH_VERSINFO[0]}" -lt 4 ]]; then
  printf 'Bash 4 or higher required' >&2;
  exit 5;
fi


# Need either awk or gawk for floating point
is-executable awk && AWK_EX="awk"
is-executable gawk && AWK_EX="gawk"
if [[ -z $AWK_EX ]] ; then
  printf >&2 'Neither awk nor gawk installed\n'
  exit 127
fi

mult=10
# Credit
# https://unix.stackexchange.com/questions/40786/how-to-do-integer-float-calculations-in-bash-or-other-languages-frameworks
frac=$($AWK_EX "BEGIN {print 1/$mult}")
timeout=$($AWK_EX "BEGIN {print $timeout*$mult}")

chars='-\|/'
for (( ct = $timeout-1; ct >= 0; ct-- )); do
  idx=$(($ct % ${#chars}))
  printf '%s %d %s \r' "${chars:$idx:1}" "$(( ($ct / $mult) + 1))" "${chars:$idx:1}"
  read -s -t $frac -n 1 key
  if [[ -z "$esc_char" && $key != "" ]]; then
    break
  elif [[ -n "$esc_char" && $key == $esc_char ]]; then
    break
  fi
done
printf '            \r'

if [[ $ct -ge 0 ]]; then
  # User escaped!
  exit 0
fi

# Timed out
exit 1
