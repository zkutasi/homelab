#!/bin/bash

USER=qta
GROUP=users

ROOT=/export

echo "Finding files not owned by ${USER}..."
find ${ROOT} \! -user ${USER} -print

echo "Fixing the ownerships..."
chown -R ${USER}:${GROUP} ${ROOT}/*/*
chmod -R 777 ${ROOT}/*/*

echo "Rechecking..."
find ${ROOT} \! -user ${USER} -print

echo "DONE"
