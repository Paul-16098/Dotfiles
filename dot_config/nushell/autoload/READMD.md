# doc By numd

> By numd

## chezmoi-completion.nu

```nu s
use chezmoi-completion
ls-commands chezmoi-completion | to md
```

Output:

```
# => | name | description |
# => | --- | --- |
# => | chezmoi | Manage your dotfiles across multiple diverse machines, securely |
# => | chezmoi add | Add an existing file, directory, or symlink to the source state |
# => | chezmoi age | Interact with age |
# => | chezmoi apply | Update the destination directory to match the target state |
# => | chezmoi archive | Generate a tar archive of the target state |
# => | chezmoi cat | Print the target contents of a file, script, or symlink |
# => | chezmoi cat-config | Print the configuration file |
# => | chezmoi cd | Launch a shell in the source directory |
# => | chezmoi chattr | Change the attributes of a target in the source state |
# => | chezmoi completion | Generate shell completion code |
# => | chezmoi data | Print the template data |
# => | chezmoi decrypt | Decrypt file or standard input |
# => | chezmoi destroy | Permanently delete an entry from the source state, the destination directory, and the state |
# => | chezmoi diff | Print the diff between the target state and the destination state |
# => | chezmoi doctor | Check your system for potential problems |
# => | chezmoi dump | Generate a dump of the target state |
# => | chezmoi dump-config | Dump the configuration values |
# => | chezmoi edit | Edit the source state of a target |
# => | chezmoi edit-config | Edit the configuration file |
# => | chezmoi edit-config-template | Edit the configuration file template |
# => | chezmoi encrypt | Encrypt file or standard input |
# => | chezmoi execute-template | Execute the given template(s) |
# => | chezmoi forget | Remove a target from the source state |
# => | chezmoi generate | Generate a file for use with chezmoi |
# => | chezmoi git | Run git in the source directory |
# => | chezmoi ignored | Print ignored targets |
# => | chezmoi import | Import an archive into the source state |
# => | chezmoi init | Setup the source directory and update the destination directory to match the target state |
# => | chezmoi license | Print license |
# => | chezmoi managed | List the managed entries in the destination directory |
# => | chezmoi merge | Perform a three-way merge between the destination state, the source state, and the target state |
# => | chezmoi merge-all | Perform a three-way merge for each modified file |
# => | chezmoi purge | Purge chezmoi's configuration and data |
# => | chezmoi re-add | Re-add modified files |
# => | chezmoi secret | Interact with a secret manager |
# => | chezmoi source-path | Print the source path of a target |
# => | chezmoi state | Manipulate the persistent state |
# => | chezmoi status | Show the status of targets |
# => | chezmoi target-path | Print the target path of a source path |
# => | chezmoi unmanaged | List the unmanaged files in the destination directory |
# => | chezmoi update | Pull and apply any changes |
# => | chezmoi upgrade | Upgrade chezmoi to the latest released version |
# => | chezmoi verify | Exit with success if the destination state matches the target state, fail otherwise |
```
