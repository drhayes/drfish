function ghclone -a repo thingy --description "Clone a repo from GitHub to ~/src."
  set -l default_path $repo
  if test -z "$thingy"
    set thingy $default_path
  end
  cd ~/src
  git clone git@github.com:$repo $thingy
  cd $thingy
end
