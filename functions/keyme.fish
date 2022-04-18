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
  if test -z "$KEYME_SSH_DB_NAME"
    _keyme_error "Please set KEYME_SSH_DB_NAME and try again."
    return 1
  end

  if test -z (which go)
    _keyme_error "It looks like go isn't installed, aborting."
    return 1
  end

  if test -z (which skate)
    _keyme_info "Skate not found, installing..."
    go install github.com/charmbracelet/skate@latest
  end


  # Ensure an empty directory to place ssh config.
  if test -d $TMP_SSH_KEY_DIR
    _keyme_info "Purging $TMP_SSH_KEY_DIR..."
    rm -rf $TMP_SSH_KEY_DIR
  end

  mkdir -p $TMP_SSH_KEY_DIR 2>/dev/null
  chown $USER:$USER "$TMP_SSH_KEY_DIR"
  chmod 700 "$TMP_SSH_KEY_DIR"

  _keyme_info "Installing SSH items..."

  # Get a list of items in the SSH skate database.
  for item_id in (skate list @$KEYME_SSH_DB_NAME --keys-only)
    _keyme_info "Fetching $item_id..."
    set SSH_DIR_FILE "$TMP_SSH_KEY_DIR/$item_id"
    skate get $item_id@$KEYME_SSH_DB_NAME > $SSH_DIR_FILE
    chmod 400 $SSH_DIR_FILE
  end

  # If there is a key matching the username.hostname pattern for this
  # username and hostname, set that key as id_rsa{,.pub}.
  set DEFAULT_KEY (whoami).(hostname)
  if test -f $TMP_SSH_KEY_DIR/$DEFAULT_KEY
    _keyme_info "Matching key found, setting as default..."
    cp $TMP_SSH_KEY_DIR/$DEFAULT_KEY $TMP_SSH_KEY_DIR/id_rsa
    cp $TMP_SSH_KEY_DIR/$DEFAULT_KEY.pub $TMP_SSH_KEY_DIR/id_rsa.pub
    _keyme_info "Running ssh-add on the default identities..."
    ssh-add
  end

  _keyme_info "Setting permissions on config..."
  chmod 600 "$TMP_SSH_KEY_DIR/config"

  # Replace the user .ssh directory.
  _keyme_info "Replacing $HOME/.ssh..."
  set HOME_SSH "$HOME"/.ssh

  if test -d $HOME_SSH
    rm -rf $HOME_SSH
  end

  ln -s "$TMP_SSH_KEY_DIR" "$HOME_SSH"
end
