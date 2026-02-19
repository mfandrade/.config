if command -q go
    fish_add_path (go env GOBIN)
end
