# Changing Git Submodule Repository to other URL/Branch

*Sep 19, 2019 Originally published at tech.serhatteker.com on Jan 3, 2019*

## List the details in .gitmodules file

This command lists all the submodules present in the current repository with their paths, URL location and the branch which it is mapped in the repository.
```
$  git config --file=.gitmodules -l
```

Output will be like:

```
submodule.external/mylib.path=external/mylib
submodule.external/mylib.url=https://github.com/alexcvc/mylib.git
submodule.external/mylib.branch=docker
```

## Edit the Submodule URL

This command will edit the URL of the submodule and will place it with the specified new URL repository.

```
$  git config --file=.gitmodules submodule.external/mylib.url https://github.com/alexcvc/mylib2.git
```

## Edit the Submodule Branch

This command will edit the Branch of the submodule and will place it in the specified Branch development.

```
$  git config --file=.gitmodules submodule.external/mylib.branch development
```

## Sync and update the Submodule

```
$  git submodule sync
$  git submodule update --init --recursive --remote
```

These commands will sync and update the submodule to the newly specified branch or URL successfully.
