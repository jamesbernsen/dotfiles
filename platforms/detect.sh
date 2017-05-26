UNAME_S="$(uname -s)"
case $UNAME_S in
  'Linux')     PLATFORM='Linux'   ;;
  CYGWIN*)     PLATFORM='Cygwin'  ;;
  'WindowsNT') PLATFORM='Windows' ;;
  'Darwin')    PLATFORM='MacOS'   ;;
  'SunOS')     PLATFORM='Solaris' ;;
  *)           PLATFORM='other'   ;;
esac

echo "Identified platform ($UNAME_S) as \"$PLATFORM\""
export PLATFORM

# Clean up
unset UNAME_S
