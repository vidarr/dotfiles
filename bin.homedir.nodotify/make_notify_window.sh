#!/usr/bin/env bash
###############################################################################
#
#       Copyright (c) 2019 German Aerospace Center DLR e.V. (GSOC)
#
#       Licensed under the Apache License, Version 2.0 (the "License");
#       you may not use this file except in compliance with the License.
#       You may obtain a copy of the License at
#
#               http://www.apache.org/licenses/LICENSE-2.0
#
#       Unless required by applicable law or agreed to in writing, software
#       distributed under the License is distributed on an "AS IS" BASIS,
#       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#       See the License for the specific language governing permissions and
#       limitations under the License.
#
#       This file is part of the openvocs project. https://openvocs.org
#
# \author             Michael J. Beer, michael.josef.beer@googlemail.com
# \date               2019-07-09
#
###############################################################################

FIFO=/tmp/notify_window_text.s

if [ ! -e $FIFO ]; then
    mkfifo $FIFO
fi

if [ "X$1" != "X" ]; then
    echo "$1" > $FIFO
    exit 0
fi

while read line < $FIFO
do
    notify-send "Cron message" "$line"
done
