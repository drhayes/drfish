function newfunc --description "Create a new drfish function."
  set filename ~/src/drfish/functions/$argv.fish
  touch $filename
  subl $filename
end
