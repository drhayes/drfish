function _keyme_error --description "Echo an error message in a pretty color."
  set_color red
  echo $argv
  set_color normal
end

function _keyme_info --description "Echo an informative message in a pretty color."
  set_color blue
  echo $argv
  set_color normal
end

function keyme --description "Pull my SSH config from secure storage and put it on disk so I can use it."
  set -l TMP_SSH_KEY_DIR /run/user/(id -u)/.ssh

  # Do we have an ID to grab the SSH config from?
  if test -z "$KEYME_SSH_CONFIG_ID"
    _keyme_error "Please set KEYME_SSH_CONFIG_ID and try again."
    return 1
  end
  # Do we have a folder full of SSH keys?
  if test -z "$KEYME_SSH_FOLDER_ID"
    _keyme_error "Please set KEYME_SSH_FOLDER_ID and try again."
    return 1
  end

  # Log into Bitwarden for secure storage. This sets BW_SESSION for later use.
  set -gx BW_SESSION (_bw_get_session)
  if test $status -ne 0
    _keyme_error "There was a problem getting the bitwarden session."
    return 1
  end

  # Ensure an empty directory to place ssh config.
  set SSH_CONFIG_PATH "$TMP_SSH_KEY_DIR"/config
  if test -d $TMP_SSH_KEY_DIR
    _keyme_info "Purging $TMP_SSH_KEY_DIR..."
    rm -rf $TMP_SSH_KEY_DIR
  end
  mkdir -p $TMP_SSH_KEY_DIR 2>/dev/null
  chown $USER:$USER "$TMP_SSH_KEY_DIR"
  chmod 700 "$TMP_SSH_KEY_DIR"
  _keyme_info "Installing SSH config..."
  bw get item "$KEYME_SSH_CONFIG_ID" | jq --raw-output .notes > $SSH_CONFIG_PATH
  chmod 600 $SSH_CONFIG_PATH
  # Get a list of items in the SSH folder.
  _keyme_info "Extracting SSH keys..."
  set ITEM_IDS (bw list items --folderid "$KEYME_SSH_FOLDER_ID" | jq --raw-output '.[].id')
  for item_id in $ITEM_IDS
    set ATTACHMENTS (bw get item $item_id | jq --compact-output '.attachments[]')
    for attachment in $ATTACHMENTS
      set ATTACHMENT_ID (echo $attachment | jq --raw-output '.id')
      set ATTACHMENT_FILE_NAME (echo $attachment | jq --raw-output '.fileName')
      set ATTACHMENT_PATH "$TMP_SSH_KEY_DIR"/"$ATTACHMENT_FILE_NAME"
      # Looks like bw doesn't want to write to /run/user/1000 or whatever...
      bw get attachment $ATTACHMENT_ID --itemid $item_id --output $HOME/run/
      _keyme_info "Moving to $ATTACHMENT_PATH..."
      mv $HOME/run/$ATTACHMENT_FILE_NAME $ATTACHMENT_PATH
      chmod 400 $ATTACHMENT_PATH
    end
  end
  # Replace the user .ssh directory.
  _keyme_info "Replacing $HOME/.ssh..."
  set HOME_SSH "$HOME"/.ssh
  if test -d $HOME_SSH
    rm -rf $HOME_SSH
  end
  ln -s "$TMP_SSH_KEY_DIR" "$HOME_SSH"
end
