function npmls --description "List the scripts section in package.json."
  if test ! -e package.json
    set_color red
    echo "No package.json file found in current directory."
    set_color normal
    return 1
  end

  cat package.json | jq .scripts
end

