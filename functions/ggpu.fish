function ggpu --description "git push origin <current branch> --set-upstream"
  git push origin (git rev-parse --abbrev-ref HEAD) --set-upstream $argv
end
