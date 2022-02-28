function _drenv_progress --description "Show a progress message"
  echo (set_color blue)"$argv"(set_color normal)
end

function _drenv_present -a name --description "Show a message that things are present."
  echo (set_color green)$name(set_color normal) is present.
end

function _sudo
  if test (id -u) -eq 0
      eval $argv
  else
      sudo $argv
  end
end

function _apt_get_install -a to_install check --description "If we don't already have it, install it."
  if test -z $check
    set check $to_install
  end
  # If we already have it, do nothing.
  if not type --quiet $check
    _drenv_progress $to_install
    DEBIAN_FRONTEND=noninteractive sudo apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install -y $to_install
  else
    _drenv_present $to_install
  end
end

function _download
  curl -sLO $argv
end

function drenv-setup --description "Do all the first time setup stuff to make a computer I want to use."
  _sudo apt-get update
  _apt_get_install "apt-utils apt-extracttemplates"
  _apt_get_install "locales update-locale"
  _sudo locale-gen
  _sudo dpkg-reconfigure locales

  set -x LC_ALL en_US.UTF-8

  # I want a local bin dir.
  mkdir -p ~/bin

  # Stable packages.
  set apps_to_install git curl wget unzip "nodejs node" npm bat jq silversearcher-ag fd-find fortune moreutils
  for app in $apps_to_install
    _apt_get_install $app
  end

  # The corner cases.

  # exa.
  if not type --quiet exa
    pushd /tmp > /dev/null
    _download https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip
    unzip exa-linux-x86_64-0.9.0.zip
    mv exa-linux-x86_64 ~/bin
    popd > /dev/null
  end

  # nvim.
  if not type --quiet nvim
    _drenv_progress nvim
    _download https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    mv nvim.appimage ~/bin/nvim
  end

  # ponysay.
  if not type --quiet ponysay
    _drenv_progress ponysay
    _sudo add-apt-repository ppa:vincent-c/ponysay
    _sudo apt-get update
    _sudo apt-get install ponysay
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
    _apt_get_install libjs-underscore
    _apt_get_install libjs-sphinxdoc
    _download https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    popd > /dev/null
  end

  # docker.
  if not type --quiet docker
    _drenv_progress docker
    pushd /tmp > /dev/null
    # Not sure this works, multilines are... enh.
    set -l docker_install (_download 'https://get.docker.com')
    bash -c $docker_install
    eval _sudo usermod -aG docker $USER
  end

  # docker-compose.
  if not type --quiet docker-compose
    _drenv_progress docker-compose
    _sudo _download 'https://github.com/docker/compose/releases/download/1.27.4/docker-compose-(uname -s)-(uname -m)' -o '/usr/local/bin/docker-compose'
    _sudo chmod +x /usr/local/bin/docker-compose
  end

  # prettyping.
  if not type --quiet prettyping
    _drenv_progress prettyping
    pushd /tmp > /dev/null
    _download https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping
    _sudo cp prettyping /usr/local/bin
    _sudo chmod +x /usr/local/bin/prettyping
    popd > /dev/null
  end

  # fzf.
  if not type --quiet fzf
    _sudo apt-get install fzf
  end

  # bat.
  # There's a chance bat isn't in the repos yet, so do it manually if necessary.
  if not type --quiet bat
    _drenv_progress bat
    pushd /tmp > /dev/null
    # Hope I'm always running this on amd64, nyuk nyuk nyuk.
    _download https://github.com/sharkdp/bat/releases/download/v0.15.4/bat_0.15.4_amd64.deb
    _sudo dpkg -i bat_0.15.4_amd64.deb
    popd > /dev/null
  end

  if not type --quiet rustc
    _drenv_progress rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  end

  # Install mssql stuff.
  _sudo apt-get install mssql-tools msodbcsql17 unixodbc libodbc1

  # Fish-specific stuff goes down here.

  # Grab the config.
  _drenv_progress Checking config...
  if not test -f ~/.config/fish/config.fish
    pushd /tmp > /dev/null
    _download https://raw.githubusercontent.com/drhayes/drfish/main/config.fish
    cp config.fish ~/.config/fish/config.fish
    popd > /dev/null
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
    pushd /tmp > /dev/null
    _download https://raw.githubusercontent.com/drhayes/drenv/main/fishfile
    cp fishfile ~/.config/fish/fishfile
    popd > /dev/null
  else
    _drenv_present fishfile
  end

  # Run fisher to grab our plugins.
  _drenv_progress Running fisher...
  fisher
end
