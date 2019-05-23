#!/bin/bash

if [ ! -f "${WORKSPACEDIR}/package.json" ]; then
    cp -rfT ${SRCDIR} ${WORKSPACEDIR}
fi

if [ ! -d "${WORKSPACEDIR}/node_modules" ]; then
    ln -sf "${HOME}/node_modules" "${WORKSPACEDIR}/node_modules"
fi

sh -c "yarn && ng serve --host 0.0.0.0" &
sleep infinity
