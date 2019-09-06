# Helper tools for Kali packagers


## setup-team-repos
How to checkout all Kali packages at once, assuming that the current
directory is the checkout of this repository:

```
$ ./bin/setup-team-repos ~/kali/packages
[>] I will setup '/home/g0tmi1k/kali/packages/.mrconfig' to easily checkout all repositories.
[?] Shall I proceed? [Y/n] y
[>] I will run 'mr --force checkout' to clone all repositories.
[?] Shall I proceed? [Y/n] y
mr checkout: /home/g0tmi1k/kali/packages/0trace
Cloning into '0trace'...
[...]

mr checkout: finished (477 ok; 0 failed)
$
```

You might want to update the `mrconfig` file listing all repositories
just to ensure that it is up-to-date:

```
$ ./bin/update-mrconfig
```

- - -

## update-control

Inside a package directory, run `bin/auto-update` to apply many Kali
specific customizations:
- updating the Maintainer field to the official value
- adding/updating Vcs-Git and Vcs-Browser fields
- adding/updating debian/gbp.conf
- adding/updating debian/kali-ci.yaml

## file-issues

If you have to file the same issue agains a large number of GitLab
projects, you can use this script. Example use:
$ apt install python3-gitlab gitlab-cli
$ bin/file-issues kalilinux/packages/kismet data/issue-details.yml

You need to have configured your API token in ~/.python-gitlab.cfg
following the template provided in
/usr/share/doc/gitlab-cli/examples/python-gitlab.cfg:
