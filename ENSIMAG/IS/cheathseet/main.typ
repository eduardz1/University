#import "@preview/cram-snap:0.2.2": cram-snap, theader

#set page(
  paper: "a4",
  flipped: true,
  margin: 1cm,
)
#set text(font: "New Computer Modern", size: 11pt)

#show: cram-snap.with(
  title: [OpenSSL Cheathseet],
  icon: image("git-icon.svg"),
)

#table(
  theader[Basics],
  [`openssl version -a`], [Checking version],
  [`openssl speed -multi 4 rsa`], [Host fast it runs on the sysem four CPU cores and testing RSA algorithm],
  [`openssl help`], [Get basic help],
  [`openssl rand -hex 20`], [Generate 20 random bytes and show them on screen],
)

#table(
  theader[Encoding/Decoding],
  [`openssl base64 -in file.data`], [Encoding a file using Base64],
  [`echo -n "some text" | openssl base64`], [Encoding some text using Base64],
  [`openssl base64 -d -in encoded.data -out decoded.data`], [Base64 decode a file with output to another file],
)

#table(
  theader[Working with Hashes],
  [`openssl list -digest-algorithms`], [List digest algorithms available],
  [`openssl dgst -sha256 file.data`], [Hash a file using SHA256],
  [`openssl dgst -binary -sha256 file.data`], [Hash a file using SHA256 with its output in binary form (no output hex encoding). _No ASCII or encoded characters will be printed to the console, just pure bytes. You can append `|xxd`_],
  [`echo -n "some text" | openssl dgst -sha3-512`], [Hash text using SHA3-512],
  [`openssl dgst -SHA384 -ma HMAX -macopt hexkey:369bd7d655`], [Hash a file using SHA256 with its output in binary form (no output hex encoding). _No ASCII or encoded characters will be printed to the console, just pure bytes. You can append `|xxd`_],
)

#table(
  theader[Reverting changes],
  [`git rebase`], [rebase the current branch on top of another specified branch],
  [`git rebase -i [commit sha]`], [start an interactive rebase],
  [`git revert [commit sha]`], [Create a new commit, reverting changes from the specified commit. It generates an *inversion* of changes.],
  [`git checkout <path>`], [discard changes in the *working tree*],
  [`git restore [-W/--worktree] <path>`], [discard changes in the *working tree*],
  [`git restore -S/--staged <path>`], [remove a file from a *staging area*],
  [`git restore -SW <path>`], [discard changes in the *working tree* and to the *staged* files],
  [`git reset <path>`], [remove a file from the *staging area*],
  [`git reset [mode] HEAD^`], [remove the latest *commit* from the current branch and:
    - `--soft` - keep file changes in the
      *working tree* and *stage* them;
    - `--mixed` - keep file changes;
    - `--keep` - reset only files which are
      different between current `HEAD` and the
      last commit
    - `--hard` - do *not* keep file changes],
)

#table(
  theader[Tagging commits],
  [`git tag`], [list all tags],
  [`git tag <name> [commit sha]`], [create a tag reference named `name` for the current or specific commit],
  [`git tag -a <name> -m <message>`], [create an annotated tag with the given message],
  [`git tag -d <name>`], [delete the tag with the given name],
)

#table(
  theader[Synchronizing repositories],
  [`git fetch [remote]`], [fetch changes from the *remote*, but not update tracking branches],
  [`git fetch --prune [remote]`], [delete remote refs that were removed from the *remote* repository],
  [`git pull [remote]`], [fetch changes from the *remote* and *merge* current branch with its upstream],
  [`git pull -r/--rebase [remote]`], [fetch changes from the *remote* and *rebase* current branch on top of the upstream],
  [`git push -u [remote] [branch]`], [push local branch to a *remote* repository and set its copy as an upstream],
)
