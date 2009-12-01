#Should source this first.  That way any options, paths, flags, etc.
#that we use in here can be set up front in there
MYBASHRC=$HOME/.mybashrc
if [ -e $MYBASHRC ]; then
	source $MYBASHRC
fi

set -o vi
export PATH=$HOME/bin:$PATH

