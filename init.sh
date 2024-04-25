#!/bin/bash

EMUX_VOL="harambe"
EMUX_DIR="./emux"
EMUX_VOL_SCRIPT="build-emux-volume"

CHECKVOL=$(docker volume inspect ${EMUX_VOL} -f '{{.Name}}')
if [ "$CHECKVOL" != "$EMUX_VOL" ]
then
    echo "Creating Docker volume $EMUX_VOL for EMUX"
    pushd $EMUX_DIR
    sh $EMUX_VOL_SCRIPT
    popd
fi
