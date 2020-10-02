function _drenv_progress --description "Show a progress message"
  echo (set_color blue)"$argv"(set_color normal)
end

function _drenv_present -a name --description "Show a message that things are present."
  echo (set_color green)$name(set_color normal) is present.
end

function _apt_get_install -a to_install check --description "If we don't already have it, install it."
  if test -z $check
    set check $to_install
  end
  # If we already have it, do nothing.
  if not which $check
    _drenv_progress $to_install
    DEBIAN_FRONTEND=noninteractive sudo apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install -y $to_install
  end
end

function drenv-setup --description "Do all the first time setup stuff to make a computer I want to use."
  sudo apt-get update

  # I want a local bin dir.
  mkdir -p ~/bin

  # Stable packages.
  set apps_to_install git curl wget "nodejs node" npm bat jq "silversearcher-ag ag" fd-find
  for app in $apps_to_install
    _apt_get_install $app
  end

  # The corner cases.

  # nvim.
  if not type --quiet nvim
    _drenv_progress nvim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    mv nvim.appimage ~/bin/nvim
  end

  # ponysay.
  if not type --quiet ponysay
    _drenv_progress ponysay
    sudo add-apt-repository ppa:vincent-c/ponysay
    sudo apt-get update
    sudo apt-get install ponysay
  end

  # fzf.
  if not type --quiet fzf
    _drenv_progress fzf
    mkdir -p $HOME/.fzf
    git clone --depth 1 "https://github.com/junegunn/fzf.git" "$HOME/.fzf"
    pushd "$HOME/.fzf" > /dev/null
    "$HOME/.fzf/install" --key-bindings --completion --update-rc
    popd > /dev/null
  end

  # kitty.
  if not type --quiet kitty
    _drenv_progress kitty
    pushd /tmp > /dev/null
    apt_get_install libjs-underscore
    apt_get_install libjs-sphinxdoc
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    popd > /dev/null
  end

  # docker.
  if not type --quiet docker
    _drenv_progress docker
    bash -c "$(curl -sLo- 'https://get.docker.com')"
    eval sudo usermod -aG docker $USER
  end

  # docker-compose.
  if not type --quiet docker-compose
    _drenv_progress docker-compose
    sudo curl -L 'https://github.com/docker/compose/releases/download/1.27.4/docker-compose-(uname -s)-(uname -m)' -o '/usr/local/bin/docker-compose'
    sudo chmod +x /usr/local/bin/docker-compose
  end

  if not type --quiet prettyping
    _drenv_progress prettyping
    pushd /tmp > /dev/null
    curl -s -O https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping
    sudo cp prettyping /usr/local/bin
    sudo chmod +x /usr/local/bin/prettyping
    popd > /dev/null
  end

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
    curl --silent --location git.io/tide | source && tide_install --unattended
  else
    _drenv_present tide
  end

  _drenv_progress Checking bat...
  if not type bat --quiet
  else
    _drenv_present bat
  end

  # Install fisher.
  _drenv_progress Checking fisher...
  if not type fisher --quiet
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
