if not test -e /usr/bin/pbpaste
    function pbpaste --description "Paste to terminal from clipboard using kitty."
        kitty +kitten clipboard --get-clipboard
    end
end
