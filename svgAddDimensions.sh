# Adds width and height equal to the values in the viewbox
#
# If no file or folder is passed as an argument
# it checks the current folder

path=$1
if [[ -z "$path" ]]; then
	path=$(pwd)/*.svg
elif [[ "$path" != *.svg ]]; then
	if [[ "$path" == */ ]]; then
		path+="*.svg"
	else
		path+="/*.svg"
	fi
fi

for file in $(grep -riL "width" $path); do
	echo $(basename -- "$file")
	sed -E -i '' "s/(viewBox=\"[[:digit:]]+ [[:digit:]]+ ([[:digit:]]+) ([[:digit:]]+)\")"/"width=\"\2\" height=\"\3\" \1/" $file
done
