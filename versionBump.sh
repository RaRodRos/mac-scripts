# First argument sets the version type: MAJOR.MINOR.PATCH
# Second argument sets a specific number
# e.g.:
# 	$ ./versionBump.sh minor 23 => x.23.x
# 	$ yarn versionBump major 2 => 2.x.x

if [[ -z "$1" || "$1" == 'patch' ]]; then
	regexSearch='\d+$'
	regexReplace='[[:digit:]]+$'
	trailingZeroes=''
elif [ "$1" == "minor" ]; then
	regexSearch='\.\d+\.'
	regexReplace='\.[[:digit:]]+\..+$'
	trailingZeroes='.0'
elif [ "$1" == "major" ]; then
	regexSearch='^\d+'
	regexReplace='^.+$'
	trailingZeroes='.0.0'
else
	echo "Error! $1 is not a correct version part" 1>&2
	exit 3
fi

currentVersion=$(egrep 'versionName "' $(pwd)/android/app/build.gradle | egrep -o '\d+\.\d+\.\d+')
selectedNumber=$(echo $currentVersion | egrep -o $regexSearch)

if [ -z "$2" ]; then
	resul=$(expr $(echo $selectedNumber | egrep -o '\d+') + 1)
else
	resul=$2
fi
resul+=$trailingZeroes

selectedNumber=$(echo $selectedNumber | sed -E "s/[[:digit:]]+.*/$resul/")
nextVersion=$(echo $currentVersion | sed -E "s/$regexReplace/$selectedNumber/")
echo $nextVersion

sed -i '' "s/versionName \"$currentVersion\"/versionName \"$nextVersion\"/" $(pwd)/android/app/build.gradle
sed -i '' "s/MARKETING_VERSION = $currentVersion;/MARKETING_VERSION = $nextVersion;/" $(pwd)/ios/feekApp.xcodeproj/project.pbxproj
