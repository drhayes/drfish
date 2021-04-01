function wa --description "Ask Wolfram Alpha for answers to stuff."
  # Do we have the Wolfram Alpha AppID from?
  if test -z "$WOLFRAM_ALPHA_APPID"
    _keyme_error "Please set WOLFRAM_ALPHA_APPID and try again."
    return 1
  end

  set VIEWER kitty +kitten icat
  set FG "white"
  set BG "transparent"

  set RESPONSE (curl --silent "https://api.wolframalpha.com/v1/result?appid=$WOLFRAM_ALPHA_APPID&units=metric&" --data-urlencode "i=$argv")

  # Did we maybe get an image?
  if test $RESPONSE = "No short answer available"
    set_color blue
    echo "Downloading full answer..."
    set_color normal
    curl --silent "https://api.wolframalpha.com/v1/simple?appid=$WOLFRAM_ALPHA_APPID&units=metric&foreground=$FG&background=$BG" --data-urlencode "i=$argv" | $VIEWER || exit 0
  end

  echo $RESPONSE
end
