#! /usr/bin/env bash

#############################################################################
show_usage() {
  progself="$1"; header="$2"; trailer="$3"

  read -r -d '' usage << USAGE_END

Usage: ${progself} [OPTION]... <SOURCE-FILE>...
Parses TODOs from code using leasot and inserts them into a Markdown file,
replacing text in that file beginning with a line like:
    ${header}

and ending with a line like:
    ${trailer}

Options:
  -h,?           display this usage information
  -k             keep a backup of the current Markdown file
  -o [filename]  the Markdown file to update with a TODO table
  -t [filetype]  force the filetype to parse. Useful if the source-file's
                 extension is unusual, changed, or removed
  -x             exit with a code of 2 if the Markdown file is modified

Examples:
  mdtodo -o README.md script.sh
  mdtodo -o TODOs.md -t .c foo.C bar.C
  mdtodo -kx -o README.md -t .py my_executable_python_script

USAGE_END

  echo
  echo "${usage}"
  echo
}


#############################################################################

# Significant exit codes
EX_SUCCESS=0
EX_FAIL=1
EX_MODIFIED=2
EX_USAGE=64

# Check for prerequisites
declare -a prereqs=("leasot" "sed" "basename" "cp" "mkdir" "mktemp" "rm" "rmdir")
for prog in "${prereqs[@]}" ; do
  command -v ${prog} > /dev/null 2>&1 || { echo >&2 "Program '${prog}' required but not found."; exit ${EX_FAIL}; }
done

# Get the name by which this script was called.
PROGSELF=$(basename $0)

HEADER='### TODOs'
TRAILER='###### TODOs parsed by [leasot](https://github.com/pgilad/leasot)'

# TODO (JRB): Read command-line options from a .mdtodo file to better automate
# the running of mdtodo with a Git pre-commit hook.

# Get command-line options
exit_fail_on_modify=false
keep_backup=false
while getopts "?hko:t:x" opt; do
  case "${opt}" in
    h|\?)
      show_usage "${PROGSELF}" "${HEADER}" "${TRAILER}"
      exit ${EX_SUCCESS} # exit with success here since usage was requested
      ;;
    k)
      keep_backup=true
      ;;
    o)
      mdfile=${OPTARG}
      ;;
    t)
      filetype_arg="--filetype ${OPTARG}"
      ;;
    x)
      exit_fail_on_modify=true
      ;;
  esac
done

shift $((OPTIND-1))

if [[ ! -r "${mdfile}" || ! -w "${mdfile}" ]] ; then
  echo >&2 "The -o option is required, and its filename must be readable and writable."
  show_usage "${PROGSELF}" "${HEADER}" "${TRAILER}"
  exit ${EX_USAGE}
fi

if [[ "$#" -lt "1" ]] ; then
  echo >&2 "One or more source filenames are required."
  show_usage "${PROGSELF}" "${HEADER}" "${TRAILER}"
  exit ${EX_USAGE}
fi

# Credit: https://stackoverflow.com/questions/29613304/is-it-possible-to-escape-regex-metacharacters-reliably-with-sed
ESCAPE_LITERAL_RGX='s/[^^]/[&]/g; s/\^/\\^/g'

HEADER_RGX=$(sed "${ESCAPE_LITERAL_RGX}" <<<"${HEADER}")
TRAILER_RGX=$(sed "${ESCAPE_LITERAL_RGX}" <<<"${TRAILER}")

mytmpdir=$(mktemp --directory --tmpdir pid$$.XXXXXXXXXX)
tailfile=$(mktemp --tmpdir=$mytmpdir tail.XXXXXXXXXX)
joutfile=$(mktemp --tmpdir=$mytmpdir jout.XXXXXXXXXX)
moutfile=$(mktemp --tmpdir=$mytmpdir mout.XXXXXXXXXX)
mkdir -p ${mytmpdir}
backupfile="${mytmpdir}/${mdfile}"
$(cp ${mdfile} ${mytmpdir})

# In the markdown file, capture any text after the trailer pattern to a file.
sed "0,\\|${TRAILER_RGX}|d" ${mdfile} > ${tailfile}

# In the markdown file, delete any text after the header pattern.
sed -i "\\|^${HEADER_RGX}\$|,\$d" ${mdfile}

# TODO (JRB): attempt to auto-detect filetypes

# Generate leasot output and handle exit codes.
leasot --exit-nicely --reporter json --skip-unsupported ${filetype_arg} $@ &> ${joutfile}
lea_ex=$?
my_ex=127
case "${lea_ex}" in
  0)
    # If leasot found no TODOs or FIXMEs, then restore the file and we're done.
    if [[ $(< ${joutfile}) == '[]' ]]; then
      echo "No TODOs or FIXMEs found..."
      # Restore the previous markdown "tail" to the file.
      cat ${tailfile} >> ${mdfile}
      exit ${EX_SUCCESS}
    fi

    cat ${joutfile} | leasot-reporter --exit-nicely --reporter markdown &> ${moutfile}
    learep_ex=$?
    if [[ "${learep_ex}" -eq "1" ]]; then
      echo "Leasot reporter exited with an error code ($learep_ex)..."
      cat ${moutfile}
      exit ${EX_FAIL}
    fi

    cat ${moutfile} >> ${mdfile}
    echo "${TRAILER}" >> ${mdfile}

    # Restore the previous markdown "tail" to the file.
    cat ${tailfile} >> ${mdfile}

    # Did the Markdown file content change?
    $(cmp -s ${mdfile} ${backupfile})
    modified=$?

    if [[ ${keep_backup} = true ]] ; then
      echo "${backupfile}"
    else
      rm -f ${backupfile}
    fi

    # rm -f ${tailfile} ${joutfile}
    # rm -f ${tailfile} ${moutfile}
    rmdir --ignore-fail-on-non-empty ${mytmpdir}

    if [[ "${modified}" -gt "0" && ${exit_fail_on_modify} = true ]] ; then
      my_ex=${EX_MODIFIED}
    else
      my_ex=${EX_SUCCESS}
    fi
    ;;
  1)
    echo "Leasot exited with an error code ($lea_ex)..."
    cat ${joutfile}
    my_ex=${EX_FAIL}
    ;;
esac

exit ${my_ex}
