function .bw_get_session --description "Get the Bitwarden session, logging in and unlocking the vault if needed."
  if not set key_id (keyctl request user bw_session 2>/dev/null);
    if not bw login --check 2>&1 >/dev/null
      bw login --apikey
    end
    if not bw unlock --check 2>&1 >/dev/null
      set BW_SESSION (bw unlock --raw)
    end
    set key_id (echo $BW_SESSION | keyctl padd user bw_session @u)
  end
  set BW_SESSION (keyctl pipe "$key_id")
  echo $BW_SESSION
end
