function glgpass --description "Grab my SSO password from storage and put it in on my clipboard."
  if test -z $GLG_SSO_ITEM_ID
    set_color red
    echo "Please set GLG_SSO_ITEM_ID first."
    set_color normal
    return 1
  end
  bw get item $GLG_SSO_ITEM_ID | jq --raw-output '.login.password' | tr --delete '\n' | kitty +kitten clipboard
end
