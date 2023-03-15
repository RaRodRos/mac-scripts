#! /usr/bin/env bash

acceleration=$(defaults read .GlobalPreferences com.apple.mouse.scaling)

if [ $acceleration -ne -1 ]; then
	echo "Disabling mouse acceleration"
	defaults write .GlobalPreferences com.apple.mouse.scaling -1
else
	echo "Enabling mouse acceleration"
	defaults write .GlobalPreferences com.apple.mouse.scaling 1
fi
