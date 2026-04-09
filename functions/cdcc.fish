function cdcc --description "cd into the ~/src/glg/gdscc directory."
  if type -q z
    z ~/src/glg/gdscc/"$argv"
  else
    cd ~/src/glg/gdscc/"$argv"
  end
end

