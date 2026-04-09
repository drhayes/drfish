function cdf --description "cd ~/.config/fish/"
  if type -q z
    z ~/.config/fish/"$argv"
  else
    cd ~/.config/fish/"$argv"
  end
end
