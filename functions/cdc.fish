function cdc --description "cd into the ~/.config folder."
  if type -q z
    z ~/.config/"$argv"
  else
    cd ~/.config/"$argv"
  end
end
