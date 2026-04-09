function cds --description "cd into the ~/src directory."
  if type -q z
    z ~/src/"$argv"
  else
    cd ~/src/"$argv"
  end
end
