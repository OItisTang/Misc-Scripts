#!/bin/bash

####################################################
#  clean up the menu for open with ...             #
####################################################

echo clean up the menu for open with ...

/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder

echo clean up OK
