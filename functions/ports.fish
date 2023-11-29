function ports --description "List process IDs associated with ports"
    sudo lsof -n -i -P | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} LISTEN | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} $argv
end
