# If CYGWIN env var is preset
if [[ ! -z ${CYGWIN+x} ]]
then
  # echo "CYGWIN var preset to \"$CYGWIN\"... saving in PRESET_CYGWIN"
  PRESET_CYGWIN=$CYGWIN
fi

# Prefer Windows-native symlinks on Cygwin
CYGWIN="$CYGWIN winsymlinks:nativestrict"

if [[ $CYGWIN = *winsymlinks:nativestrict* ]]
then
  # echo "Testing strict winsymlinks..."
  MYTMPDIR=$(mktemp --directory --tmpdir pid$$.XXXXXXXXXX)
  TEMPFILE=$(mktemp --tmpdir=$MYTMPDIR)
  TEMPLINKNAME=$(mktemp --dry-run --tmpdir)

  # Test symlink; if it fails, then warn the user
  if ! ln --force --symbolic $TEMPFILE $TEMPLINKNAME > /dev/null 2>&1
  then
      echo "** Notice: Windows-native symlinks failed. If you need them, run as Administrator."
  fi

  # Clean up
  rm -f $TEMPLINKNAME
  rm -f $TEMPFILE
  rmdir --ignore-fail-on-non-empty $MYTMPDIR
fi

# Restore CYGWIN variable if it was preset
if [[ ! -z ${PRESET_CYGWIN+x} ]]
then
  CYGWIN=$PRESET_CYGWIN
  unset PRESET_CYGWIN
fi

