function _drenv_progress --description "Show a progress message"
  echo (set_color blue)"$argv"(set_color normal)
end

function _drenv_present -a name --description "Show a message that things are present."
  echo (set_color green)$name(set_color normal) is present.
end

function drenv-setup --description "Do all the first time setup stuff to make a computer I want to use."
  # Grab the config.
  _drenv_progress Checking config...
  if not test -f ~/.config/fish/config.fish
    curl https://raw.githubusercontent.com/drhayes/drfish/main/config.fish -o ~/.config/fish/config.fish
  else
    _drenv_present config.fish
  end

  # Is tide there?
  _drenv_progress Checking tide...
  if not type tide -q
    curl -sL git.io/tide | source && tide_install --unattended
  else
    _drenv_present tide
  end

  _drenv_progress Checking bat...
  if not type bat -q
  else
    _drenv_present bat
  end

  # Install fisher.
  _drenv_progress Checking fisher...
  if not type fisher -q
    curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
    source ~/.config/fish/functions/fisher.fish
  else
    _drenv_present fisher
  end

  # Grab the fishfile.
  _drenv_progress Checking fishfile...
  if not test -f ~/.config/fish/fishfile
    curl https://raw.githubusercontent.com/drhayes/drenv/main/fishfile -o ~/.config/fish/fishfile
  else
    _drenv_present fishfile
  end

  # Run fisher to grab our plugins.
  _drenv_progress Running fisher...
  fisher
end
