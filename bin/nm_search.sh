#!/bin/sh
#
#recurse from current dir and output name of any .a files
#that contain the desired symbol.
echo "Search for: $1"
foreach i `find . -name '*.a'`
    nm --defined-only $i | grep $1
    if ($status == 0) then
        echo $i
    fi
end
