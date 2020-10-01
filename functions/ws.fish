function ws --description "Start a webserver in current directory. If not present, install first."
  if not type -q http-server
    npm install -g http-server
  end
  http-server
end
