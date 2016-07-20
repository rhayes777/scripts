filename=$1
extension="${filename##*.}"
echo $extension
filename="${filename%.*}"
if [ ! -f $1 ]; then
	touch $1
	if [ $extension='md' ];
        	then
			echo '<!-- Markdeep: --><style class=\"fallback\">body{visibility:hidden;white-space:pre;font-family:monospace}</style><script src=\"markdeep.min.js\"></script><script src=\"https://casual-effects.com/markdeep/latest/markdeep.min.js\"></script><script>window.alreadyProcessedMarkdeep||(document.body.style.visibility=\"visible\")</script>' >> $1
        	fi
fi
open $1
