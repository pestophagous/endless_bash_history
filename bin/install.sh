#!/bin/bash

# why did i think this should be a condition? why would we need to always source?
#if [ "${BASH_SOURCE[0]}" -ef "$0" ]
#then
#    echo "Hey, you should source this script, not execute it!"
#    exit 1
#fi

SCRIPT_VER=2

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ebh_histfile="~/.persistent_history"

if [[ -n ${ebh_other_dir-} ]];
# The '-' hyphen above tests without angering the 'set -u' about unbound variables
then
  ebh_histfile="${ebh_other_dir}/.persistent_history"
fi

# check if ~/.persistent_history exists and is appendable
touch "${ebh_histfile}"
if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; return -1; fi

echo '# endless_bash_history/bin/install.sh sanity check' >> "${ebh_histfile}"
if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; return -1; fi


# check if PROMPT_COMMAND is present and has uuid
if [ -z "$PROMPT_COMMAND" ]; then
    # install it
    tmpfile=$(mktemp /tmp/endless_bash_history_install.XXXXXXXX)
    ls "${THISDIR}/../data/for_bashrc"
    if [ $? != 0 ]; then echo run as 'source bin/install.sh' from git repo root; return -1; fi
    cp "${THISDIR}/../data/for_bashrc" $tmpfile
    if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; return -1; fi

    # Personalize this to your liking:
    host_unique_name=$((hostname && uuid -F SIV) | xargs echo -n | tr ' ' '-')
    echo host_unique_name is [$host_unique_name]

    sed -i "s/host_part=.hostname./host_part=$host_unique_name/"  $tmpfile
    if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; return -1; fi
    cat ~/.bashrc $tmpfile > ~/.bashrc.new
    if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; return -1; fi
    cp ~/.bashrc.new ~/.bashrc
    if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; return -1; fi
    rm ~/.bashrc.new
    if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; return -1; fi
    source ~/.bashrc
else
    # we have a prompt command.
    # complain/fail if it does not contain uuid
    found_our_uuid=$(type $PROMPT_COMMAND | grep c7056b84-e3d3-11e9-b9a3-37962ff2c46c | wc -l)
    if [ "$found_our_uuid" != "1" ]; then
        echo Cannot complete the install. Unknown PROMPT_COMMAND exists.
        return -1
    fi

    echo Install script is happy with preexisting PROMPT_COMMAND
fi
