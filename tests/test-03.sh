#!/bin/bash

set -o errexit

# shellcheck source=./setup.sh
source "$(git rev-parse --show-toplevel)/tests/setup.sh"

# Test auto-update-git with the --depth parameter.
main() {
    set-up-path
    set-up-repositories

    create-commit-in-remote
    create-commit-in-remote

    auto-update-cloned-repository-and-diff-remote --depth=2 ||
        (echo "failed test-03.sh" && exit 1)

    # shellcheck disable=SC2155
    local commit_count=$(cloned-git rev-list --count HEAD)

    if [[ $commit_count -ne 2 ]]; then
        echo "FAILURE: unexpected commit count, got: $commit_count, want: 2"
        echo "failed test-03.sh" && exit 1
    fi

    cleanup
}

main "$@"
