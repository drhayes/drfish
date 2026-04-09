function cdd --description "cd into the ~/Downloads folder."
  if type -q z
    z ~/Downloads/"$argv"
  else
    cd ~/Downloads/"$argv"
  end
end
