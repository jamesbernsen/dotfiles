# If CYGWIN env var is preset
if [[ ! -z ${CYGWIN+x} ]]
then
  # echo "CYGWIN var preset to \"$CYGWIN\"... saving in PRESET_CYGWIN"
  PRESET_CYGWIN=$CYGWIN
fi

if [[ $CYGWIN != *winsymlinks:native* ]] ; then
  echo "** Notice: Windows-native symlinks not enabled. If you want this feature, add"
  echo "           the text 'winsymlinks:native' to your CYGWIN system environment"
  echo "           variable and launch the terminal as Administrator."
else
  # Set Windows-native symlinks to strict mode for this test.
  CYGWIN="winsymlinks:nativestrict"

  # echo "Testing strict winsymlinks..."
  MYTMPDIR=$(mktemp --directory --tmpdir pid$$.XXXXXXXXXX)
  TEMPFILE=$(mktemp --tmpdir=$MYTMPDIR)
  TEMPLINKNAME=$(mktemp --dry-run --tmpdir)

  # Test symlink; if it fails, then warn the user
  if ! ln --force --symbolic $TEMPFILE $TEMPLINKNAME > /dev/null 2>&1
  then
      echo "** Notice: Could not create Windows-native symlink. If you want this feature,"
      echo "           launch the terminal as Administrator."
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

# Use Solarized Dark theme
sourcefile $DOTFILES_DIR/platforms/cygwin/themes/mintty-colors-solarized/sol.dark

