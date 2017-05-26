# Credit: http://stackoverflow.com/questions/2264428/converting-string-to-lower-case-in-bash-shell-scripting
lc() {
  LC_ALL=C  # for case-sensitive match
  case "$1" in
    [A-Z])
      n=$(printf "%d" "'$1")
      n=$((n+32))
      printf \\$(printf "%o" "$n")
      ;;
    *)
      printf "%s" "$1"
      ;;
  esac
}

tolower() {
  text=$1
  for((i=0;i<${#text};i++))
  do
    ch="${text:$i:1}"
    lch=$(lc $ch)
    ltext="${ltext}${lch}"
  done
  printf $ltext
}

