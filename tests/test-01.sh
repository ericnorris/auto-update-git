#!/bin/bash

set -o errexit

# shellcheck source=./setup.sh
source "$(git rev-parse --show-toplevel)/tests/setup.sh"

# Test the basics: that auto-update-git will fetch the latest commit.
main() {
    set-up-path
    set-up-repositories

    create-commit-in-remote

    auto-update-cloned-repository-and-diff-remote ||
        (echo "failed test-01.sh" && exit 1)

    cleanup
}

main "$@"
