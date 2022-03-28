function fish_greeting
  which cowsay 2>&1 > /dev/null
  if test -z $status
    fortune | cowsay | lolcat
  end
end
