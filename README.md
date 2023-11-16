`nixos-profiles-tool`
=====================

*Tool that helps managing NixOS generations.*

* * *

What's this used for?
---------------------

Ever rebuilt and had the boot partition too full to complete?

Ever wanted to pick which generations to keep instead of `--delete-old`?

This tool aims to provide plumbing and bare porcelain to manage such things, and a few extras.

* * *

Usage
-----

```
 $ nixos-profiles-tool remove-generation --help
Usage: nixos-profiles-tool [global-opts] <command>

Commands:
  check-boot-files      Checks files status under the `/boot` partition
  prune-boot-files      Prune files outside of existing generations from the `/boot` partition
  list-generations      List generation in a user-friendly manner
  remove-generation     Remove a given generation
  remove-generations    Remove generations given parameters
  dump-generations      Dump system profile generations information to JSON

Global options:
        --boot-partition=PART        Boot directory or partition (defaults to /boot)
        --root=ROOT                  Filesystem root (e.g. /mnt)
        --version                    Prints the version

 $ nixos-profiles-tool remove-generation
Usage: remove-generation <id>

 $ nixos-profiles-tool remove-generations --help
Remove generations given parameters
        --before-id=ID               Removes generations before the given ID
        --max=COUNT                  Keeps at most COUNT generations
```


* * *

FAQ
---

### Why Ruby?

Because.

Anyway, it's not really important.
I needed to get a stable interface out for another project.
As long as the interface is respected, it can be rewritten in anything.
It likely will in the future.
