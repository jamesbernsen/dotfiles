#! /usr/bin/env bash

#############################################################################
show_usage() {
  read -r -d '' usage << USAGE_END

Usage: mdtodo [OPTION]... <SOURCE-FILE>...
Parses TODOs from code using leasot and inserts them into a Markdown file

Options:
  -h,?           display this usage information
  -o [filename]  the Markdown file to update with a TODO table
  -t [filetype]  force the filetype to parse. Useful if the source-file's
                 extension is unusual, changed, or removed

Examples:
  mdtodo -o README.md script.sh
  mdtodo -o TODOs.md -t .c foo.C bar.C
  mdtodo -o README.md -t .py my_executable_python_script

USAGE_END

  echo
  echo "$usage"
  echo
}


#############################################################################

# Check for prerequisites
declare -a prereqs=("leasot" "sed")
for prog in "${prereqs[@]}" ; do
  command -v $prog > /dev/null 2>&1 || { echo >&2 "Program '$prog' required but not found."; exit 1; }
done

# Get command-line options
while getopts "h?o:t:" opt; do
  case "$opt" in
    h|\?)
      show_usage
      exit 0
      ;;
    o)
      mdfile=$OPTARG
      ;;
    t)
      filetype_arg="--filetype $OPTARG"
      ;;
  esac
done

shift $((OPTIND-1))

EX_USAGE=64

if [[ ! -r "$mdfile" || ! -w "$mdfile" ]] ; then
  echo >&2 "The -o option is required, and its filename must be readable and writable."
  show_usage
  exit $EX_USAGE
fi

if [[ "$#" -lt "1" ]] ; then
  echo >&2 "One or more source filenames are required."
  show_usage
  exit $EX_USAGE
fi

HEADER='### TODOs'
TRAILER='###### TODOs parsed by [leasot](https://github.com/pgilad/leasot)'

# Credit: https://stackoverflow.com/questions/29613304/is-it-possible-to-escape-regex-metacharacters-reliably-with-sed
ESCAPE_LITERAL_RGX='s/[^^]/[&]/g; s/\^/\\^/g'

HEADER_RGX=$(sed "$ESCAPE_LITERAL_RGX" <<<"$HEADER")
TRAILER_RGX=$(sed "$ESCAPE_LITERAL_RGX" <<<"$TRAILER")

mytmpdir=$(mktemp --directory --tmpdir pid$$.XXXXXXXXXX)
tempfile=$(mktemp --tmpdir=$mytmpdir)

# In the markdown file, capture any text after the trailer pattern to a file.
sed "0,\\|$TRAILER_RGX|d" $mdfile > $tempfile

# In the markdown file, delete any text after the header pattern.
sed -i "\\|^$HEADER_RGX\$|,\$d" $mdfile

# Append the table and trailer to the markdown file.
leasot --reporter markdown $filetype_arg $@ >> $mdfile
echo "$TRAILER" >> $mdfile

# Restore the previous markdown "tail" to the file.
cat $tempfile >> $mdfile

rm -f $tempfile
rmdir --ignore-fail-on-non-empty $mytmpdir

