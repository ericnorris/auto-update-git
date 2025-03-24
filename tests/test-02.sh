#!/bin/bash

set -o errexit

# shellcheck source=./setup.sh
source "$(git rev-parse --show-toplevel)/tests/setup.sh"

# Test that auto-update-git will clear any modifications to the local repository.
main() {
    set-up-path
    set-up-repositories

    create-commit-in-remote

    create-commit-in-cloned
    touch "$CLONED_DIR/dirty"
    cloned-git checkout -b some-other-branch

    auto-update-cloned-repository-and-diff-remote ||
        (echo "failed test-02.sh" && exit 1)

    cleanup
}

main "$@"
