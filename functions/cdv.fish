function cdv --description "cd into the ~/the-vault directory"
  if type -q z
    z ~/the-vault/"$argv"
  else
    cd ~/the-vault/"$argv"
  end
end

