function cdg --description "cd into the go directory"
    cd (go env GOPATH)/src/"$argv"
end
