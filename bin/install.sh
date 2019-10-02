#!/bin/bash

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

SCRIPT_VER=1

# check if ~/.persistent_history exists and is appendable
touch ~/.persistent_history
if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; return -1; fi

echo '# endless_bash_history/bin/install.sh sanity check' >> ~/.persistent_history
if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; return -1; fi


# check if PROMPT_COMMAND is present and has uuid
if [ -z "$PROMPT_COMMAND" ]; then
    # install it
    tmpfile=$(mktemp /tmp/endless_bash_history_install.XXXXXXXX)
    ls data/for_bashrc
    if [ $? != 0 ]; then echo run as 'source bin/install.sh' from git repo root; return -1; fi
    cp data/for_bashrc $tmpfile
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

sudo cp bin/push_endless_bash.sh /usr/bin/
sudo chmod 0755 /usr/bin/push_endless_bash.sh

sudo cp pluggables/mv001/endless_bash_pluggable_push /usr/bin/endless_bash_pluggable_push
sudo chmod 0755 /usr/bin/endless_bash_pluggable_push
