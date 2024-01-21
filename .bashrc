# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi


unset rc
stty intr "^Z"
stty susp "^X"
export XDG_CONFIG_HOME=$HOME/.config
export SPARK_HOME=~/Applications/spark-3.3.0-bin-hadoop3/
export PATH=$PATH:$SPARK_HOME/python:$PYTHONPATH

export PYSPARK_PYTHON=python
export PATH=$PATH:$JAVA_HOME/jre/bin

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$"
PS1="\[\033[37m\][\u@\h \[\033[32m\]\w\[\033[37m\]]\[\033[00m\]\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$ "


