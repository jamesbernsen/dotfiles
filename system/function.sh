# Helper function for sourcing scripts
sourcefile() {
  [[ -f "$1" && -r "$1" ]] && source "$1"
}


is-executable() {
  local BIN=$(command -v "$1" 2>/dev/null)
  if [[ ! $BIN == "" && -x $BIN ]]; then true; else false; fi
}


# With a single argument ($1):
#   Returns true if the command ($1) exits with success and prints nothing to
#   stderr.
# With multiple arguments ($1 $2 [$3])
#   Returns $2 if the command ($1) exits with success and prints nothing to
#   stderr, otherwise returns $3.
is-supported() {
  CMD_ERR="$($1 2>&1 > /dev/null)"
  if [ $# -eq 1 ]; then
    if eval "$1" > /dev/null 2>&1 && [[ -z $CMD_ERR ]]; then true; else false; fi
  else
    if eval "$1" > /dev/null 2>&1 && [[ -z $CMD_ERR ]]; then
      echo -n "$2"
    else
      echo -n "$3"
    fi
  fi
}


# Add to path
prepend-path() {
  [[ -d $1 ]] && PATH="$1:$PATH"
}


# Update config file
set-config() {
  local KEY="$1"
  local VALUE="$2"
  local FILE="$3"
  touch "$FILE"
  if grep -q "$1=" "$FILE"; then
    sed "s@$KEY=.*@$KEY=\"$VALUE\"@" -i "$FILE"
  else
    echo "export $KEY=$VALUE" >> "$FILE"
  fi
}


# Show 256 TERM colors
colors() {
  local X=$(tput op)
  local Y=$(printf %$((COLUMNS-6))s)
  for i in {0..256}; do
  o=00$i;
  echo -e ${o:${#o}-3:3} $(tput setaf $i;tput setab $i)${Y// /=}$X;
  done
}
