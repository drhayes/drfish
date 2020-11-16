function .runsudo --description 'Run current command as sudo.'
  commandline -C 0
  commandline -i 'sudo '
  commandline -f execute
end

bind \es .runsudo
