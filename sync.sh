#!/bin/bash

export LITE_REPO_SYNC
LITE_REPO_SYNC="https://github.com/abaicus/hestia.git";

export LITE_NAME=$(node -pe "require('./package.json').litename");

if [ "$LITE_REPO_SYNC" ] && [ "$LITE_NAME" ]; then
	if [ ! -d "artifact" ]; then
		grunt deploy
	fi
	git clone "$LITE_REPO_SYNC" -b master ../"$LITE_NAME"

fi

