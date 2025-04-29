function psi --description "ps aux | grep -i"
    ps aux | grep -i $argv | grep -v 'grep --color=auto -i '
end
