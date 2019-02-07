#!/bin/bash

export LITE_REPO_SYNC
LITE_REPO_SYNC="abaicus/hestia";
export THEMEISLE_VERSION="2.0.99"


#Get the lite name from the package.json file.
export LITE_NAME=$(node -pe "require('./package.json').litename");

if [ "$LITE_REPO_SYNC" ] && [ "$LITE_NAME" ]; then
	# Check if the dist folder already exists. If not, run grunt deploy.
	if [ ! -d "dist" ]; then
		grunt deploy
	fi
	# Remove lite if is already there (we need to clone the repo here).
	if [ -d ../"$LITE_NAME" ]; then
		rm -rf ../"$LITE_NAME"
	fi
	# Clone the lite repo in the same place that the lite version will be generated.
	git clone https://github.com/"$LITE_REPO_SYNC" -b master ../"$LITE_NAME"
	# Copy the files from the lite version in dist to the cloned repo folder (recursive | verbose).
	cp -Rv dist/"$LITE_NAME"/* ../"$LITE_NAME"/
	# Change dir into the cloned repo folder.
	cd ../"$LITE_NAME"/

	# Commit and push
	git add * -v
	git commit -am "Version v$THEMEISLE_VERSION" --no-verify
	git push --quiet

	# Tag release
	git tag -a "v$THEMEISLE_VERSION" -m "Release of $THEMEISLE_VERSION";
	git push --quiet --tags;

	# Go back to build directory.
	cd "$TRAVIS_BUILD_DIR" || exit 1
fi

