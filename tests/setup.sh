#!/bin/bash

set-up-path() {
    # shellcheck disable=SC2155
    export PATH="$(git rev-parse --show-toplevel)/bin:$PATH"
}

set-up-repositories() {
    PARENT_DIR="$(mktemp -d)"

    REMOTE_DIR="$PARENT_DIR/remote"
    CLONED_DIR="$PARENT_DIR/cloned"

    REMOTE_COMMIT_COUNT=0
    CLONED_COMMIT_COUNT=0

    mkdir "$REMOTE_DIR" "$CLONED_DIR"

    remote-git init

    create-commit-in-remote
    create-commit-in-remote

    cloned-git clone "file://$REMOTE_DIR" .
}

remote-git() {
    git -C "$REMOTE_DIR" "$@"
}

create-commit-in-remote() {
    local file="foo-$((REMOTE_COMMIT_COUNT++))"

    touch "$REMOTE_DIR/$file"

    remote-git add .
    remote-git commit -m "add $file"
}

cloned-git() {
    git -C "$CLONED_DIR" "$@"
}

create-commit-in-cloned() {
    local file="bar-$((CLONED_COMMIT_COUNT++))"

    touch "$CLONED_DIR/$file"

    cloned-git add .
    cloned-git commit -m "add $file"
}

auto-update-cloned-repository-and-diff-remote() {
    local diff_output

    # shellcheck disable=SC2164
    cd "$CLONED_DIR"

    if [[ $1 =~ --depth= ]]; then
        auto-update-git "$1" "file://$REMOTE_DIR"
    else
        auto-update-git "file://$REMOTE_DIR"
    fi

    if ! diff_output=$(diff <(remote-git show HEAD) <(cloned-git show HEAD)); then
        echo "FAILURE: cloned HEAD does not match remote: $diff_output"
        return 1
    fi

    if ! diff_output=$(diff <(remote-git ls-files) <(cloned-git ls-files --cached --deleted --modified --others)); then
        echo "FAILURE: cloned files do not match remote files: $diff_output"
        return 1
    fi

    return 0
}

cleanup() {
    if [[ -n $PARENT_DIR ]]; then
        rm -rf "$PARENT_DIR"
    fi
}
