# How To Add and Update Git Submodules

[https://devconnected.com/author/schkn/]()

If you are a developer working on a large project, you are probably already familiar with the concept of Git submodules.
Git submodules are most of the time used in order to incorporate another versioned project within an existing project.
Submodules can be used for example in order to store third-party libraries used by your main project in order to compile successfully.
In order to keep up with the changes made for those third-party libraries, you choose to include projects as submodules in your main project.
In this tutorial, we are going to explain how you can easily add, update and remove Git submodules on your main project.
We are also going to explain concepts about Git submodules, what they are and how they should be worked with on a Git repository.

## Add a Git Submodule

The first thing you want to do is to add a Git submodule to your main project.
In order to add a Git submodule, use the “git submodule add” command and specify the URL of the Git remote repository to be included as a submodule.
Optionally, you can also specify the target directory (it will be included in a directory named as the remote repository name if not provided)

```shell
$ git submodule add <remote_url> <destination_folder>
```

When adding a Git submodule, your submodule will be staged. As a consequence, you will need to commit your submodule by using the “git commit” command.

```shell
$ git commit -m "Added the submodule to the project."
$ git push
```

As an example, let’s pretend that you want to add the “project” repository as a submodule on your project into a folder named “vendors”.
To add “project” as a submodule, you would run the following command at the root of your repository

```shell
$ git submodule add https://github.com/project/project.git vendors

Cloning into '/home/user/main/project'...
remote: Enumerating objects: 5257, done.
remote: Total 5257 (delta 0), reused 0 (delta 0), pack-reused 5257
Receiving objects: 100% (5257/5257), 3.03 MiB | 3.38 MiB/s, done.
Resolving deltas: 100% (3319/3319), done.
```

When adding a new Git submodule into your project, multiple actions will be performed for you :

1. A folder is created in your Git repository named after the submodule that you chose to add (in this case “vendors”);
1. A hidden file named “.gitmodules” is created in your Git repository : this file contains the references to the remote repositories that you cloned as submodules;
1. Your Git configuration (located at .git/config) was also modified in order to include the submodule you just added;
1. The submodule you just added are marked as changes to be committed in your repository.

## Pull a Git Submodule

In this section, we are going to see how you can pull a Git submodule as another developer on the project.
Whenever you are cloning a Git repository having submodules, you need to execute an extra command in order for the submodules to be pulled.
If you don’t execute this command, you will fetch the submodule folder, but you won’t have any content in it.
To pull a Git submodule, use the “git submodule update” command with the “–init” and the “–recursive” options.

```shell
$ git submodule update --init --recursive
```

Going back to the example we described before : let’s pretend that we are in a complete new Git repository created by our colleague.
In its Git repository, our colleague first starts by cloning the repository, however, it is not cloning the content of the Git submodule.
To update its own Git configuration, it has to execute the “git submodule update” command.

```shell
$ git submodule update --init --recursive

Submodule 'vendors' (https://github.com/project/project.git) registered for path 'vendors'
Cloning into '/home/colleague/submodules/vendors'...
Submodule path 'vendors': checked out '43d08138766b3592352c9d4cbeea9c9948537359'
```

As you can see, pulling a Git submodule in our colleague Git repository detached the HEAD at a given commit.

The submodule is always set to have its HEAD detached at a given commit by default : as the main repository is not tracking the changes of the submodule, it is only seen as a specific commit from the submodule repository.

## Update a Git Submodule

In some cases, you are not pulling a Git submodule but you are simply look to update your existing Git submodule in the project.
In order to update an existing Git submodule, you need to execute the “git submodule update” with the “–remote” and the “–merge” option.

```shell
$ git submodule update --remote --merge
```

Using the “–remote” command, you will be able to update your existing Git submodules without having to run “git pull” commands in each submodule of your project.
When using this command, your detached HEAD will be updated to the newest commit in the submodule repository.
Given the example that we used before, when updating the submodule, we would get the following output

```shell
$ git submodule update --remote --merge

Updating 43d0813..93360a2
Fast-forward
 README.md | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)
Submodule path 'vendors': merged in '93360a21dc79011ff632b68741ac0b9811b60526'
```

## Fetch new submodule commits

In this section, you are looking to update your Git repository with your commits coming from the submodule repository.
First, you may want to fetch new commits that were done in the submodule repository.
Let’s say for example that you want to fetch two new commits that were added to the submodule repository.
To fetch new commits done in the submodule repository, head into your submodule folder and run the “git fetch” command first (you will get the new submodule commits)

```shell
$ cd repository/submodule
$ git fetch
```

Now, if you run the “git log” command again, you will be able to see the new commits you are looking to integrate.

```shell
$ git log --oneline origin/master -3

93360a2 (origin/master, origin/HEAD) Second commit
88db523 First commit
43d0813 (HEAD -> master) Initial commit
```
Now, in order for your submodule to be in-line with the newest commits, you can run the “git checkout” command and specify the SHA that you want to update your submodule to (in this case 93360a2)

```shell
$ git checkout -q 93360a2
```

Great! Your HEAD is now aligned with the newest commits from the submodule repository.

You can now go back to your main repository and commit your changes for other developers to fetch those new commits.

```shell
$ cd repository
$ git add .
$ git commit -m "Added new commits from the submodule repository"
$ git push
```

## Remove Git submodules

In this section, we are going to see how you can effectively remove a Git submodule from your repository.
In order to remove a Git submodule from your repository, use the “git submodule deinit” command followed by the “git rm” command and specify the name of the submodule folder.

```shell
$ git submodule deinit <submodule>
$ git rm <submodule>
```

When executing the “git submodule deinit” command, you will delete the local submodule configuration stored in your repository.
As a consequence, the line referencing the submodule will be deleted from your .git/config file.
The “git rm” command is used in order to delete submodules files from the working directory and remaining .git folders.

## Configuring submodules for your repository

In some cases, you may want to have additional logging lines whenever you are executing “git status” commands.
Luckily for you, there are configuration properties that you can tweak in order to have more information about your submodules.

## Submodule summary

In order to have a submodule summary when executing “git status”, execute the “git config” command and add the “status.submoduleSummary” option.

```shell
$ git config --global status.submoduleSummary true
```

As a consequence, you will be presented with more information when executing “git status” commands.

```shell
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

  new file:   .gitmodules
  new file:   <submodule>

Submodule changes to be committed:
* <submodule> 0000000...ae14a2 (1):
  > Change submodule name
```

## Detailed diff for submodules

If you configured your Git to have the submodule summary as explained in the previous section, you should now have a customized way to see differences between submodules.
However, in some cases, you want to get more information about the commits that might have been done in your submodules folder.
For the “git diff” command to have detailed information about your submodules, use the “git config” command with the “diff.submodule” parameter set to true.

```shell
$ git config --global diff.submodule log
```

Now, whenever you are executing the “git diff” command, you will be able to see the commits that were done in the submodules folder.

```shell
$ git diff

Submodule <submodule> 0000000...ae14a2:
  > Submodule commit n°1
  > Submodule commit n°2
```

