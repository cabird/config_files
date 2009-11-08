export ALIASDIR="$HOME/.osxaliases"
OSXDIRLIST="/Applications $HOME/Applications /Developer/Applications /Developer/Applications/Utilities"

if [ ! -e $ALIASDIR ]
then
	mkdir -p $ALIASDIR
fi

for dir in $OSXDIRLIST
do
	file=`echo $dir | sed -e 'y#/#_#'`
	if [ ! -e $ALIASDIR/$file -o $ALIASDIR/$file -ot $dir ] 
	then
		rm -f $ALIASDIR/$file
		echo "Updating $dir aliases..."
		find $dir -name '*.app' -prune -or -name '*.dock' -prune | awk\
		'{\
			appl = $0;\
			count = split(appl,path,/\/|\.app|\.dock/);\
			name = path[count-1];\
			name = tolower(name);\
			gsub(/ |\(|\)|\"|'\\\''/, "", name);\
			gsub(/'\''/, "'\''\\'\'\''", appl);\
			gsub(/\"/, "\\\"", appl);\
			printf "alias %s=\"open -a %c%s%c\"\n",name,39,appl,39;\
		}' > $ALIASDIR/$file
	else
		echo "$dir aliases are up to date."
	fi
done

source $HOME/.bashrc
for dir in $ALIASDIR/*
do
	  source $dir
done

unalias vim
unalias gvim
 
export PATH=$PATH:/Library/PostgreSQL8/bin
export PATH=$PATH:/Applications/gvim.app/Contents/MacOS/

test -r /sw/bin/init.sh && . /sw/bin/init.sh
source /usr/local/bin/git-completion.bash
