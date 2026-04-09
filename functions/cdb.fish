function cdb --description "cd into the ~/bin folder."
  if type -q z
    z ~/bin/"$argv"
  else
    cd ~/bin/"$argv"
  end
end
