# auto-update-git

`auto-update-git` is a bash script to automatically update a `git` repository to match the current state of a given remote git repository. It should handle any modification to the local repository: new commits, file modifications, a changed branch, and untracked files. It does not require hard-coding the `HEAD` branch of the remote repository, and should continue working if the remote repository's `HEAD` branch changes.

It can also do a "shallow" fetch from the remote repository, if you would like to only keep the last N commits on disk.

## Usage

```shell
cd <repository>
auto-update-git [--depth=<depth>] <remote-url>
```

## How it works

The core algorithm is:

1. Ensure that the `git` repository has a remote called `origin` pointing at `<remote-url>`.
2. Set the `HEAD` of the remote automatically, thus discarding any local changes to the remote `HEAD`, or picking up a new remote `HEAD`.
3. Determine which branch the remote `HEAD` points to.
4. Fetch the branch the remote `HEAD` points to.
5. Forcibly checkout the branch the remote `HEAD` points to, potentially changing the current branch and overwriting any changes to a local branch of the same name.
6. Delete any branches other than the branch the remote `HEAD` points to.
7. Clean any untracked files.

## Testing

There are crude (but effective) tests in the `tests/` directory, you may execute them individually, for example:

```sh
./tests/test-01.sh
```
