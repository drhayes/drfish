function cdl --description "cd into the ~/.local directory"
  if type -q z
    z ~/.local/"$argv"
  else
    cd ~/.local/"$argv"
  end
end
