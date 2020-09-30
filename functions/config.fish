function config --description "git ops on my dotfiles"
  /usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME $argv
end
