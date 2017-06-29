#! /usr/bin/env bash

# Check for prerequisites
declare -a prereqs=("leasot" "sed")
for prog in "${prereqs[@]}" ; do
  command -v $prog > /dev/null 2>&1 || { echo >&2 "Program '$prog' required but not found. Aborting."; exit 1; }
done

MDFILE=$1; shift
HEADER='### TODOs'
TRAILER='###### TODOs parsed by [leasot](https://github.com/pgilad/leasot)'

# Credit: https://stackoverflow.com/questions/29613304/is-it-possible-to-escape-regex-metacharacters-reliably-with-sed
ESCAPE_LITERAL_RGX='s/[^^]/[&]/g; s/\^/\\^/g'

HEADER_RGX=$(sed "$ESCAPE_LITERAL_RGX" <<<"$HEADER")
TRAILER_RGX=$(sed "$ESCAPE_LITERAL_RGX" <<<"$TRAILER")

MYTMPDIR=$(mktemp --directory --tmpdir pid$$.XXXXXXXXXX)
TEMPFILE=$(mktemp --tmpdir=$MYTMPDIR)

# In the markdown file, capture any text after the trailer pattern to a file.
sed "0,\\|$TRAILER_RGX|d" $MDFILE > $TEMPFILE

# In the markdown file, delete any text after the header pattern.
sed -i "\\|^$HEADER_RGX\$|,\$d" $MDFILE

# Append the table and trailer to the markdown file.
leasot --reporter markdown $@ >> $MDFILE
echo "$TRAILER" >> $MDFILE

# Restore the previous markdown "tail" to the file.
cat $TEMPFILE >> $MDFILE

rm -f $TEMPFILE
rmdir --ignore-fail-on-non-empty $MYTMPDIR

