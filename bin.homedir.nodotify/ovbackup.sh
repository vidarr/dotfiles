#!/bin/bash
export BACKUP_TARGET=vocs@hoedur:source
# MUST BE ABSOLUTE!!!
export OVDIR=/home/beer/projekte/ov/openvocs1
export REPO_NAME=openvocs1
export TMP_DIR=$(mktemp -d)

function mirror_repo() {

    cd $TMP_DIR
    git clone --bare $OVDIR
    cd $OVDIR
    git push --mirror $TMP_DIR/$REPO_NAME.git

}

function create_tarball() {
    tarball=$1/openvocs1-$(date +%Y%m%d).tar.gz
    tar cf - $1/$2.git | gzip - > $tarball
    echo $tarball
}

mirror_repo
echo "Mirrored REPO to $TMP_DIR"

TARBALL=$(create_tarball $TMP_DIR $REPO_NAME)
echo "Created $TARBALL"
rsync -avrz $TARBALL $BACKUP_TARGET
echo "Synched $TARBALL to $BACKUP_TARGET"
rm -rf $TMP_DIR
