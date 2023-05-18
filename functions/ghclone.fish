function ghclone -a repo thingy --description "Clone a repo from GitHub to ~/src."
    set -l default_path $repo
    if test -z "$thingy"
        set thingy $default_path
    end
    # Am I forgetting that I already cloned that? If so, just send me there.
    # But go ahead and update it because why not.
    if test -d $HOME/src/$thingy
        cd $HOME/src/$thingy
        git pull
        return
    end
    cd $HOME/src
    git clone git@github.com:$repo $thingy
    cd $thingy
end
