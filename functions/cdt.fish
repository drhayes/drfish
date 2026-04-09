function cdt --description "cd into the ~/tmp directory."
  if type -q z
    z ~/tmp/"$argv"
  else
    cd ~/tmp/"$argv"
  end
end
