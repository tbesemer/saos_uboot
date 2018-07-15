#!/bin/sh

if [ -z "$1" ]
then
    echo "do_chk_env.sh: Expect either 'set' or 'clear'"
    exit 1
else
    IS_SET=$1
fi

if [ "$OECORE_SDK_VERSION" == "2.2.4" ]
then
    if [ "$IS_SET" == "set" ]
    then
        exit 0
    else
	echo "do_chk_env.sh: Environment Set, Error"
        exit 1
    fi
else
    if [ "$IS_SET" == "clear" ]
    then
        exit 0
    else
	echo "do_chk_env.sh: Environment Clear, Error"
        exit 1
    fi
fi

