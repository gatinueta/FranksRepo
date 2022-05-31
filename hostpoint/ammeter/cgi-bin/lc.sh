#!/bin/sh
cd ..
perl -pi.bak -w -e 's/(DSC.*?\.[jJ][pP][gG])/lc $1/ge;' */*.html

