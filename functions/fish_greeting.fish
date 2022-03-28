function fish_greeting
  if (which cowsay)
    fortune | cowsay | lolcat
  end
end
