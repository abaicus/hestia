#!/bin/bash

export LITE_REPO_SYNC
LITE_REPO_SYNC="abaicus/hestia";
export THEMEISLE_VERSION="1.0.1"


#Get the lite name from the package.json file.
export LITE_NAME=$(node -pe "require('./package.json').litename");

if [ "$LITE_REPO_SYNC" ] && [ "$LITE_NAME" ]; then
	# Check if the dist folder already exists. If not, run grunt deploy.
	if [ ! -d "dist" ]; then
		grunt deploy
	fi
	# Clone the lite repo in the same place that the lite version will be generated.
	git clone https://github.com/"$LITE_REPO_SYNC" -b master ../"$LITE_NAME"
	# Copy the files from the lite version in dist to the cloned repo folder.
	cp -Rv dist/"$LITE_NAME"/* ../"$LITE_NAME"/
	# Change dir into the cloned repo folder.
	cd ../"$LITE_NAME"/

	# Commit and push
	ls
	git status
   git add * -v
   git commit -am "Version v$THEMEISLE_VERSION" --no-verify
   git push --quiet

   # Tag release
   git tag -a "v$THEMEISLE_VERSION" -m "Release of $THEMEISLE_VERSION";
   git push --quiet --tags;

   cd "$TRAVIS_BUILD_DIR" || exit 1
fi

