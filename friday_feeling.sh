rm ~/Desktop/temp/*
programs=("X11" "SelfControl" "Navicat" "Navicat" "PyCharm" "MacDown" "Coda" "Xcode" "Coda 2" "Coda 2 (20074) 2" "Pages" "Numbers" "Preview" "Mail" "Chrome" "TextEdit" "Advanced REST Client" "Safari" "Simulator" "Inkscape" "Gimp" "Terminal")
for i in "${programs[@]}"
do
	echo $i
	osascript -e 'quit app "'$i'"'
done
