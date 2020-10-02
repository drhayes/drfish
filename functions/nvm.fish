function nvm --description "Use bass to run nvm."
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end
