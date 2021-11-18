# Helper tools for Kali packagers

Helper scripts to manage the huge set of repositories used for Kali packages.

## Setup

To make use of some of the scripts, you need to setup a "Personal Access
Token" granting access to the "api". You do that here:
<https://gitlab.com/profile/personal_access_tokens>

Store your key in the `.gitlab-token` file (within this folder) with this
command (replace XXX with the real token):

```bash
$ echo "SALSA_TOKEN='XXX'" > ./.gitlab-token
```

You will also need to have configured your API token in: `~/.python-gitlab.cfg`.
There is a template provided in: `/usr/share/doc/gitlab-cli/examples/python-gitlab.cfg`.

You also need `curl`, the `salsa` tool (from the `devscripts` package), `gbp`
(aka. `git-buildpackage`) and `mr` (aka. `myrepos`):

```bash
$ sudo apt update
$ sudo apt -y install curl devscripts git-buildpackage myrepos   python3-gitlab gitlab-cli
```

### setup-team-repos: Checkout all repositories in a dedicated directory

You might want to update the `mrconfig` file listing all repositories
just to ensure that it is up-to-date:

```bash
$ ./bin/update-mrconfig
```

- - -

To checkout all Kali packages at once, assuming that the current
directory is the checkout of this repository:

```bash
$ ./bin/setup-team-repos ~/kali/packages
[>] I will setup '/home/user/kali/packages/.mrconfig' to easily checkout all repositories.
[?] Shall I proceed? [Y/n] y
[>] I will run 'mr --force checkout' to clone all repositories.
[?] Shall I proceed? [Y/n] y
mr checkout: /home/user/kali/packages/0trace
Cloning into '0trace'...
gbp:info: Cloning from 'git@gitlab.com:kalilinux/packages/dpkg.git'
[...]
mr checkout: finished (578 ok; 0 failed)
$
```

- - -

Over time, repositories will be archived for various reasons. If you wish to move these folders to a differnet location

```bash
$ ./bin/archive-team-repos ~/kali/packages/ ~/kali/archive
[>] I will compare '/home/g0tmi1k/kali/packages/.mrconfig' to '/home/g0tmi1k/kali/packages' to see any packages which have been archived
[?] Shall I proceed? [Y/n] y
[...]
$
```

- - -

_One liner to handle all local repo work: `~/kali/tools/bin/update-mrconfig && ~/kali/tools/bin/setup-team-repos ~/kali/packages/ && ~/kali/tools/bin/archive-team-repos ~/kali/packages/ ~/kali/archive`_

### configure-packages: Configure git packaging repositories

This script makes use of the GitLab API to setup:
- the email notifications,
- standardize the description,
- ensure `kali/master` is the default branch,
- enable the merge requests and the issues,
- and configure the CI path to `debian/kali-ci.yml`.

It is a wrapper around Debian's `salsa` tool (provided by `devscripts`).

To verify all repositories from the packages sub-group and reconfigure those
which are not consistent with our rules:

```bash
$ ./bin/configure-packages --all
```

To configure a new repository in the packages sub-group:

```bash
$ ./bin/configure-packages zaproxy
```

### archive-package: Disable an unused git repository

To archive an obsolete project in the packages sub-group:

```bash
$ ./bin/archive-package ruby-librex
```

After having used that command you should update the list of repositories
with `./bin/update-mrconfig`.

### auto-update: Apply common changes for all Kali source packages

Assuming that `$PACKAGING_DIR` contains the path to this git repository,
once inside a package directory, run `$PACKAGING_DIR/bin/auto-update` to
apply many Kali specific customizations:

- updating the `Maintainer` field to the official value
- updating `Vcs-Git` and `Vcs-Browser` fields
- adding/updating `debian/gbp.conf`
- adding/updating `debian/kali-ci.yaml`

### file-issues: Create many GitLab issues

If you have to file the same issue against a large number of GitLab
projects, you can use this script. Example use:

```bash
$ ./bin/file-issues kalilinux/packages/kismet data/issue-details.yml
```
