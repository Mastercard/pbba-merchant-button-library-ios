#!/bin/bash
# Author: Alex Maimescu

# Required tools
#  - xcodebuild: Xcode command line tool
#  - jazzy: Install ruby gem (sudo gem install jazzy)
REQUIRED_PROGRAMS_IN_PATH=(
	"xcodebuild"
 	"jazzy"
)

function validateTools() {

	count=0
	while [ "x${REQUIRED_PROGRAMS_IN_PATH[$count]}" != "x" ]
	do
	   	program=${REQUIRED_PROGRAMS_IN_PATH[$count]}

		hash $program 2>/dev/null
		if [ $? -eq 1 ]; then
			echo >&2 "ERROR - $program is not installed or not in your PATH"; exit 1;
		fi

	   count=$(( $count + 1 ))
	done
}

# Validate toolset
echo "[VALIDATE TOOLSET]"
validateTools

# Run tests
echo "[GENERATE DOCS]"
jazzy --objc --umbrella-header "ZappMerchantLib/ZappMerchantLib.h" --framework-root "." --sdk iphonesimulator

echo "[OPEN DOCSET]"
open "docs/index.html"