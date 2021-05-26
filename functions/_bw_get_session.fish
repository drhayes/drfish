function _bw_get_session --description "Get the Bitwarden session, logging in and unlocking the vault if needed."
  # Is our Bitwarden username set?
  if test -z $BW_USERNAME
    echo "Please set BW_USERNAME before continuing."
    return 1
  end

  # Is our Bitwarden session key still in keyctl?
  set KEY_ID (keyctl request user bw_session 2>/dev/null)
  if test -z $KEY_ID
    # It's not! Time to login.
    bw login --check > /dev/null 2>&1
    set logged_in $status

    if test $logged_in -eq 0
      set BW_SESSION (bw unlock --raw)
    else
      set BW_SESSION (bw login --raw "$1")
    end

    # Stick the session in keyctl and save the key id for later retrieval.
    set KEY_ID (echo -n $BW_SESSION | keyctl padd user bw_session @u)
  end

  # Seconds into the future, BTW...
  keyctl timeout "$KEY_ID" 900
  echo -n (keyctl pipe "$KEY_ID")
end
