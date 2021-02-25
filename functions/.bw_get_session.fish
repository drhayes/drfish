function .bw_get_session --description "Get the Bitwarden session, logging in and unlocking the vault if needed."
  # Is our Bitwarden session key still in keyctl?
  set KEY_ID (keyctl request user bw_session 2>/dev/null)
  if test -z "$KEY_ID"
    # It's not! Time to login.
    if not bw login --check 2>&1 >/dev/null
      bw login --apikey
    end
    # Unlock the shizz and store the session ID for a bit.
    if not bw unlock --check 2>&1 >/dev/null
      set -x BW_SESSION (bw unlock --raw)
    end
    # Stick the session in keyctl and save the key id for later retrieval.
    set KEY_ID (echo -n $BW_SESSION | keyctl padd user bw_session @u)
  end
  # Seconds into the future, BTW...
  keyctl timeout "$KEY_ID" 900
  echo -n (keyctl pipe "$KEY_ID")
end
