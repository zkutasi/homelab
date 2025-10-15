#!/bin/bash

USER=qta
GROUP=users

ROOT=/export

echo "Finding files not owned by ${USER}..."
sudo find ${ROOT} \! -user ${USER} -print

echo "Fixing the ownerships..."
sudo chown -R ${USER}:${GROUP} ${ROOT}/*/*
sudo chmod -R 777 ${ROOT}/*/*

echo "Rechecking..."
sudo find ${ROOT} \! -user ${USER} -print

echo "DONE"
