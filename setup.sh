#!/usr/bin/env bash
#------------------------------------------------------------------------------
#
# Copyright (c) 2020 German Aerospace Center DLR e.V. (GSOC)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This file is part of the openvocs project. https://openvocs.org
#
#------------------------------------------------------------------------------
#
# Comprehensive description of this python script
#
# @author Michael J. Beer, DLR/GSOC
# @copyright (c) 2020 German Aerospace Center DLR e.V. (GSOC)
# @date 2020-08-05
#
#------------------------------------------------------------------------------

PLUGIN_DIR=plugin.scripts

SOURCE_DIR=$(pwd)

function install_files () {

    SUFFIX=$1
    TARGET_DIR=$2
    DOTIFY=$3

    for F in *.$SUFFIX; do

        TF=$(echo $F | sed -e "s/\(.*\).$SUFFIX/\1/")

        if [ "X$DOTIFY" != "X" ]; then
            TF=".$TF"
        fi

        TF=$TARGET_DIR/$TF
        SF=$SOURCE_DIR/$F

        echo "Installing $SF as $TF"

        rm $TF -r
        ln -s $SF $TF

    done

}

#------------------------------------------------------------------------------
#                                     MAIN
#------------------------------------------------------------------------------

install_files homedir $HOME "dotify"
install_files homedir.nodotify $HOME
install_files config $HOME/.config

for SCRIPT in $PLUGIN_DIR/*.sh; do

    bash $SCRIPT

done


