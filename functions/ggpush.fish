function ggpush --description "git push origin <current branch>"
  git push origin (git rev-parse --abbrev-ref HEAD) $argv
end
