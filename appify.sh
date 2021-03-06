#!/usr/bin/env bash

Appify="$(basename "$0")"

if [ ! "$1" -o "$1" = "-h" -o "$1" = "--help" ]; then cat <<EOF
    Appify v4.1 for Mac OS X
    Creates the simplest possible Mac OS X app from a shell script.
    
    Takes a shell script as its first argument:
    
        $Appify path/to/my-script
    
    NOTE: You cannot rename appified apps, blame Mac OS X.
    If you want to give your app a custom name, use the second argument:
    
        $Appify path/to/my-script "My App"
    
    Copyright © 2010-2011 Thomas Aylott <http://subtlegradient.com>
    Copyright © 2011 Mathias Bynens <http://mathiasbynens.be>
    Copyright © 2011 Sencha, Inc.

EOF
exit; fi

FILE="$1"
NAME="${2:-$(basename "$FILE" .sh)}"
ROOT="$NAME.app/Contents/MacOS"

if [[ -a "$NAME.app" ]]; then
    echo "$PWD/$NAME.app already exists :(" 1>&2
    exit 1
fi

mkdir -p "$ROOT"

if [ -f "$FILE" ]; then
    cp  "$FILE" "$ROOT/$NAME"
    echo "Copied $ROOT/$NAME" 1>&2

else
    touch "$ROOT/$NAME"
    echo "Created blank $ROOT/$NAME" 1>&2
fi

chmod +x "$ROOT/$NAME"

echo "$PWD/$NAME.app"