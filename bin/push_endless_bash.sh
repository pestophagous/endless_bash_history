#!/bin/bash

SCRIPT_VER=1

# is there a .persistent_history ?
ls ~/.persistent_history > /dev/null
if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; exit -1; fi

timeprefix=$(date --iso-8601=minutes | tr ':' '_')

tmpfile=$(mktemp "/tmp/${timeprefix}.persistent_history.XXXXXXXX")
if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; exit -1; fi

# is there a .persistent_history.trailing ?
if [ -e ~/.persistent_history.trailing ]; then
    # if so, then diff PH and PHT, put new content in timestamp_uuid
    diff ~/.persistent_history ~/.persistent_history.trailing | cut -c3- > $tmpfile
    if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; exit -1; fi
else
    # since we did not find the "trailing" log, we will back up the whole main log
    cp ~/.persistent_history $tmpfile
    if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; exit -1; fi
fi

# run pluggable function on file:
endless_bash_pluggable_push $tmpfile
if [ $? != 0 ]; then echo early termination at v$SCRIPT_VER:$LINENO; exit -1; fi

# cp PH onto PHT
cp ~/.persistent_history ~/.persistent_history.trailing
