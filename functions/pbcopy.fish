if not test -e /usr/bin/pbcopy
    function pbcopy --description "Copy to clipboard from command-line using kitty."
        kitty +kitten clipboard
    end
end
