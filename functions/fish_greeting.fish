function fish_greeting
  which cowsay 1>2 /dev/null
  if test -z $status
    fortune | cowsay | lolcat
  end
end
