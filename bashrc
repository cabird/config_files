#Should source this first.  That way any options, paths, flags, etc.
#that we use in here can be set up front in there
MYBASHRC=$HOME/.mybashrc
if [ -e $MYBASHRC ]; then
	source $MYBASHRC
fi

set -o vi
export PATH=$HOME/bin:$PATH
export PATH=~/bin:/usr/local/mysql/bin:/opt/local/bin:/usr/local/bin:/usr/local/texlive/2007/bin/i386-darwin/:$PATH
function parse_git_dirty {
[[ $(git status 2> /dev/null | tail -n1 | grep -o "nothing") != "nothing" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

set -o vi

export PS1='\h \[\033[1;31m\]\w\[\033[0m\]$(parse_git_branch)$ '
 

