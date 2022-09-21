function shclone -a repo thingy --description "Clone a repo from sourcehut to ~/src."
  set -l default_path $repo
  if test -z "$thingy"
    set thingy $default_path
  end
  # Am I forgetting that I already cloned that? If so, just send me there.
  if test -d $HOME/src/$thingy
    cd $HOME/src/$thingy
    return
  end
  cd $HOME/src
  git clone git@git.sr.ht:~$repo $thingy
  cd $thingy
end

