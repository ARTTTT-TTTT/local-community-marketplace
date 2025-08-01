#!/bin/bash

# * chmod +x scripts/linux/clean-branches.sh
# * ./scripts/linux/clean-branches.sh 

git remote prune origin

remote_branches=$(git branch -r | grep origin/ | sed 's/origin\///')

current_branch=$(git branch --show-current)
local_branches=$(git branch | sed 's/^[* ]*//')

for branch in $local_branches; do
    if [[ "$branch" == "$current_branch" ]] || [[ "$branch" == "main" ]]; then
        continue
    fi

    if ! echo "$remote_branches" | grep -q "^${branch}$"; then
        echo "Deleting local branch '$branch' as it no longer exists on origin"
        git branch -D "$branch"
    fi
done
