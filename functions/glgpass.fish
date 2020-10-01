function glgpass
  lpass show glg-sso-login --password | tr -d '\n' | kitty +kitten clipboard
end
