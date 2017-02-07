
echo Loaded hubert.bash

#echo `date +%H:%M:%S` >> $HOME/startup.log

#tmux has-session -t development
#if [ $? != 0 ]
#then
#	tmux new-session -s development
#fi
#tmux attach -t development 

alias t='tmux'
alias tn='ECHO tmux new -s'
alias ta='ECHO tmux a -t'
alias tkill='echo Will kill this sesion, proceed? ; read line ; tmux kill-session'



alias ehp='vim ~/hubert.bash'
alias rhp='source ~/hubert.bash'
alias eh='ehp && source ~/hubert.bash'

alias his='history | less'
alias rmd='rm -rf'


function SetTerminalTitle()
{
    if windows; 
    then
	    echo -ne "\e]0;$@\a"
    fi
}

alias stt='SetTerminalTitle'

# Way to check we're on windows
windows() { [[ -n "$WINDIR" ]]; }

#  ----------------------------------------- Windows

function windows_setup()
{

echo todo


}

export PATH="$PATH:/cygdrive/e/Tools/nodejs/"
export PATH="$HOME/bin:$PATH"


#  ----------------------------------------- PS1


function ps1_git_branch_name()
{
    git rev-parse --abbrev-ref HEAD 2> /dev/null || echo 
}

function ps1_git_get_sha() {
    git rev-parse --short HEAD 2>/dev/null
}

function we_are_in_git_work_tree 
{
    git rev-parse --is-inside-work-tree &> /dev/null
}

function ps1_gitify 
{
   if ! we_are_in_git_work_tree
    then
        echo ""
    else
    
      if windows
      then
        echo "$(ps1_git_branch_name)  $(ps1_git_get_sha)"
      else
        echo "$(ps1_git_branch_name) $(ps1_git_modified_files)  $(ps1_git_get_sha)"    
      fi
    
#$(git-unpushed)
    fi
}

function ps1_proc_type()
{
    if windows
    then
        echo "pc "
    else
        echo "`proc_type` $MY_SYS  `cat /sys_type` "
    fi
}


function ps1_default()
{

	export PS1="\n\n\n\[\033[35m\]\D{%d.%m} \A\[\033[m\] \[\033[33;1m\]\w\[\033[m\] \[\033[32m\] \$(ps1_gitify) \[\033[36m\] \n${COLOR_BLUE}\$(ps1_proc_type)\[\033[33;1m\]\$(hostname)\[\033[m\] \$ "

}

ps1_default


# ------------------------------------------ SSH keys


function ssh_debug()   # other than that, do ssh -vvv manually
{
	if [ $# -eq 0 ]
	then
		export SVN_SSH="ssh -v "
		echo "SSH debugging on"
	else
		export SVN_SSH="ssh "
		echo "SSH debugging off"
	fi
}


function setup_ssh_keys()
{
	cd ~/.ssh
	ssh-keygen -t rsa -f $1

# at server: chmod 600 ~/.ssh/authorized_keys ;  cd;  chmod 700 ~/.ssh;  chmod go-w $HOME

	echo "Copy $1 to server"
	# cat id_rsa_westeros.pub | ssh hrutkows@host.com 'cat >> ~/.ssh/authorized_keys'
	chmod 600 $1
	echo "Make sure there is entry in ~/.ssh/config for $1"
}


#  ----------------------------------------- Universal

function ECHO()  # uruchamia komendę i wypisuje ją w linii
{
	#tty_fg_color 2
	echo "$ $@"
	#tty_color_default
	$@
}

function ECHO_NL()  # uruchamia komendę i wypisuje ją w linii
{
	#tty_fg_color 2
	echo "$ $@"
	#tty_color_default
	echo ""
	$@
}


alias cd..="cd .."
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'


alias q='exit'

alias ll='ls -la'

# bookmark, ie. a 1  and later call 1, it will take you back to that directory
function b() { alias $1="cd $PWD"; }

alias l='ls'
alias ll='ls -lh'
alias la='ls -alh'
alias cwd='basename $PWD'

alias vimrc='vim ~/.vimrc'
alias v='vim'


#  ----------------------------------------- 

function fh()
{
	find . -name "$1"  2>/dev/null
}

function fhi()
{
	find . -iname "$1"  2>/dev/null
}

function ft()
{
	find $1 -name "$2" 2>/dev/null
}


#  ----------------------------------------- 

function time_func()
{
  date2=$((`date +%s` + $1)); 
  date1=`date +%s`; 

   while [ "$date2" -ne `date +%s` ]; do 
    echo -ne "     Since start: $(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)     Till end:  $(date -u --date @$(($date2 - `date +%s`)) +%H:%M:%S)\r";
    sleep 0.25
   done

   printf "\nTimer finished!\n"
   play_sound ~/msys/wav/finished.wav

}

function time_seconds()
{
  echo "Counting to $1 seconds"

  time_func $1
}

function time_minutes()
{
  echo "Counting to $1 minutes"

  time_func $1*60
}

function time_hours()
{
  echo "Counting to $1 hours"

  time_func $1*60*60
}

function play_sound()
{
	cat $1 > /dev/dsp
}


function hibernate_after_minutes()
{

	echo todo
}

#  ----------------------------------------- symlink

#  syntax: link $linkname $target     In windows run babun as administrator
# Important: you need to pass path in a windows format, ie. C:/Dev/metal/src instead of /c/dev/metal
# ie. link p4_fuji C:/Dev/hrutkows_apple/IGFuji

# Cross-platform symlink function. With one parameter, it will check
# whether the parameter is a symlink. With two parameters, it will create
# a symlink to a file or directory 
link() {
    if [[ -z "$2" ]]; then
        # Link-checking mode.
        if windows; then
            fsutil reparsepoint query "$1" > /dev/null
        else
            [[ -h "$1" ]]
        fi
    else
        # Link-creation mode.
        if windows; then
            # Windows needs to be told if it's a directory or not. Infer that.
            # Also: note that we convert `/` to `\`. In this case it's necessary.
            if [[ -d "$2" ]]; then
                cmd <<< "mklink /D \"$1\" \"${2//\//\\}\"" > /dev/null
            else
                cmd <<< "mklink \"$1\" \"${2//\//\\}\"" > /dev/null
            fi
        else
            # You know what? I think ln's parameters are backwards.
            ln -s "$2" "$1"
        fi
    fi
}

# Remove a link, cross-platform.
rmlink() {
    if windows; then
        # Again, Windows needs to be told if it's a file or directory.
        if [[ -d "$1" ]]; then
            rmdir "$1";
        else
            rm "$1"
        fi
    else
        rm "$1"
    fi
}


# Extra many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar -jxvf "$1"                        ;;
      *.tar.gz)   tar -zxvf "$1"                        ;;
      *.bz2)      bunzip2 "$1"                          ;;
      *.dmg)      hdiutil mount "$1"                    ;;
      *.gz)       gunzip "$1"                           ;;
      *.tar)      tar -xvf "$1"                         ;;
      *.tbz2)     tar -jxvf "$1"                        ;;
      *.tgz)      tar -zxvf "$1"                        ;;
      *.zip)      unzip "$1"                            ;;
      *.ZIP)      unzip "$1"                            ;;
      *.pax)      cat "$1" | pax -r                     ;;
      *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
      *.Z)        uncompress "$1"                       ;;
      *) echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
  else
     echo "'$1' is not a valid file to extract"
  fi
}

#  ----------------------------------------- git

alias g='git'

function git_current_branch()
{
	curr_dir=$(cwd)
	printf ""
	printf $curr_dir
	printf " is at \t" 
	git branch | grep "*"
}


# pass ask to make it wait before merge
function git_pull_filter()
{
	git fetch  > ~/.git_pull_log_stdout 2> ~/.git_pull_log_stderr 
	cat ~/.git_pull_log_stdout | grep -v "[new branch]" | grep -v "[deleted]"
	git logincoming 
	if [ -n "$1" ]  # non zero
	then
		echo "Merge?"
		read
	fi	
	git merge 
	echo "Full log in ~/.git_pull_log_stdout and ~/.git_pull_log_stderr "
}


alias gi='git '
alias gti='git '

alias gf='git fetch'
alias gd='g d --color=auto'
alias gdc='g dc'

alias grv='git remote -v'
alias ga='git add'
alias gau='git add -u'
alias gc='g ci -m'

function gau_c()
{
	    gau && gc "$1"
}


alias gd1='echo "                  diff of last commit";         ECHO git show HEAD'
alias gd2='echo "                  diff of pre-last commit";     ECHO git show HEAD^'
alias gd3='echo "                  diff of pre-pre-last commit"; ECHO git show HEAD^^'
alias gd4='echo "                  diff of pre-pre-last commit"; ECHO git show HEAD^^^'
alias gd5='echo "                  diff of pre-pre-last commit"; ECHO git show HEAD^^^'
alias gd6='echo "                  diff of pre-pre-last commit"; ECHO git show HEAD^^^^'

alias gd11='gd1'
alias gd22='echo "                 diff of 2 last commits"; ECHO git diff HEAD^^ HEAD'
alias gd33='echo "                 diff of 3 last commits"; ECHO git diff HEAD^^^ HEAD'
alias gd44='echo "                 diff of 4 last commits"; ECHO git diff HEAD^^^^ HEAD'
alias gd55='echo "                 diff of 5 last commits"; ECHO git diff HEAD^^^^^ HEAD'
alias gd66='echo "                 diff of 6 last commits"; ECHO git diff HEAD^^^^^^ HEAD'

alias gco2='g co HEAD~1'
alias gco3='g co HEAD~2'

alias g-='git checkout -'  # can't be git co -, as co is used by coflex
alias gbr='git branches'

alias gsl='git stash list'

alias gsm='gs -uno' # show only modified, without untracked
alias gs='git status -s'

alias gl='git lr'
alias gl1='gl -1'
alias gl3='gl -3'
alias gl5='gl -5'
alias gl10='gl -10'
alias gl50='gl -50'

alias deploy='g push deploy master'


#  ----------------------------------------- Webdev work

alias cdw='cd /cygdrive/e/WWW/'
alias cdh='cdw; cd WebdevHomepage/'

alias cdx='cd /cygdrive/e/xampp/htdocs/'

alias xamp='cdh; ./xamp_publish.sh'
alias html='cdh; ./xamp_publish.sh html'

alias lessc='C:/Users/Hubert/AppData/Roaming/npm/lessc.cmd'

# workaround for sass 3.4 bug not allowing to import css file
alias sassy='sass -r sass-css-importer'
alias sass_watch='sassy --watch css:css' # call it in folder above where the .scss is


# ------------ Homepage

# for angular seed admin

alias admin_serve_dev='cdh; cd admin2;    npm start -- --base /admin/'
alias admin_serve_prod='cdh; cd admin2;    npm start -- --env-config prod --base /admin/'

alias admin_build_dev='cdh; cd admin2;   npm run build.dev -- --base /admin/'
alias admin_build_prod='cdh; cd admin2;   npm run build.prod -- --base /admin/'
alias admin_build_prod_shake='cdh; cd admin2;   npm run build.prod.rollup.aot -- --base /admin/'


alias admin_build_deploy='admin_build_prod && admin_deploy'


