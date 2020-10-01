function cdtop --description "Get to the top of a git repo."
  cd "$(git rev-parse --show-toplevel)"
end
