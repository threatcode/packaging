# Helper tools for Kali packagers

_Helper scripts to manage the huge set of [repositories](https://gitlab.com/kalilinux/packages) used for [Kali packages](https://pkg.kali.org/)._

[[_TOC_]]

- - -

Example:

```bash
git clone https://gitlab.com/kalilinux/tools/packaging.git ~/kali/tools/

cd ~/kali/tools/ && \
~/kali/tools/bin/update-mrconfig && \
~/kali/tools/bin/unprotect && \
~/kali/tools/bin/configure-packages --all
~/kali/tools/bin/archive-team-repos ~/kali/packages/ ~/kali/archive/ && \
~/kali/tools/bin/setup-team-repos ~/kali/packages/ && \
ls -1 ~/kali/packages/ \
  | while read -r package; do
    cd ~/kali/packages/"$package"/;
    out=$(~/kali/tools/bin/auto-update);
    [ -n "$out" ] && echo -e "$package\n$out\n";
  done
```

## Local setup

You will need the following programs:

- `curl` <!--shell scripts -->
- `gbp` (aka `git-buildpackage`)
- `mr` (aka `myrepos`) <!-- mass cloning -->
- `salsa` (from the `devscripts` package) <!--shell scripts -->
- `python3-gitlab` & `gitlab-cli` <!--python scripts -->

```bash
$ sudo apt update
$ sudo apt install --no-install-recommends -y curl devscripts git-buildpackage myrepos python3-gitlab gitlab-cli
```

- - -

To make use of some of the scripts, you need to setup a "Personal Access Token" granting access to the "api".
You do that here:
<https://gitlab.com/-/profile/personal_access_tokens>

Store your key in the `./.gitlab-token` file (the root of this folder) with this command (replace XXX with the real token): <!--This is for shell scripts/salsa -->

```bash
$ echo "SALSA_TOKEN='XXX'" > ./.gitlab-token
```

- - -

You will also need to have configured your API token in: `~/.python-gitlab.cfg`.
There is a template provided in: `/usr/share/doc/gitlab-cli/examples/python-gitlab.cfg`:

```bash
$ cp -nv /usr/share/doc/gitlab-cli/examples/python-gitlab.cfg ~/.python-gitlab.cfg
````

## ls ./bin/

This is an overview of the scripts found in: `./bin/`

### archive-package: Disable an unused git repository

To archive an obsolete project in the packages sub-group:

```bash
$ ./bin/archive-package ruby-librex
```

After having used that command you should update the list of repositories with: `./bin/update-mrconfig`

### archive-team-repos: Move local packages that are archived remotely

Over time, repositories will be archived for various reasons _(see `./bin/archive-package`)_.
If you wish to move these folders to a different location (`~/kali/packages/` -> `~/kali/archive/`):

```bash
$ ./bin/archive-team-repos ~/kali/packages/ ~/kali/archive/
[>] I will compare '/home/user/kali/packages/.mrconfig' to '/home/user/kali/packages' to see any packages which have been archived
[?] Shall I proceed? [Y/n] y
[...]
$
```

### auto-update: Apply common changes for all Kali source packages

Assuming that `$PACKAGING_DIR` contains the path to this git repository, once inside a package directory, run `$PACKAGING_DIR/bin/auto-update` to apply many Kali specific customizations:

- Adding/updating `debian/gbp.conf`
- Adding/updating `debian/kali-ci.yaml`
- Updating `Vcs-Git` and `Vcs-Browser` fields
- Updating the `Maintainer` field to the official value

This will use the contents from: `../auto-update.d/`

- - -

Example of looping: `~/kali/packages/`:

```bash
ls -1 ~/kali/packages/ \
  | while read -r package; do
    cd ~/kali/packages/"$package"/;
    out=$(~/kali/tools/bin/auto-update);
    [ -n "$out" ] && echo -e "$package\n$out\n";
  done
```

### configure-packages: Configure remote GitLab packaging repositories

This script makes use of the GitLab API to setup:

- Configure the CI path to `debian/kali-ci.yml`
- Enable merge requests and issues
- Ensure `kali/master` is the default branch
- Setup email notifications
- Standardize the description

This will use the contents from: `../salsa/`

- - -

To verify all repositories from the packages sub-group and reconfigure those which are not consistent with our rules:

```bash
$ ./bin/configure-packages --all
```

- - -

To configure a new repository in the packages sub-group:

```bash
$ ./bin/configure-packages zaproxy
```

### file-issues: Create many GitLab issues

If you have to file the same issue against a large number of GitLab projects, you can use this script.

Example use:

```bash
$ ./bin/file-issues kalilinux/packages/kismet data/issue-details.yml
```

This will use the contents from: `../data/`


### setup-team-repos: Checkout all repositories in a dedicated directory

To checkout all Kali packages at once, assuming that the current directory is the checkout of this repository:

```bash
$ ./bin/update-mrconfig
$
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

### unprotect: Allow for force push

Will reset branch protection to allow developers to push and merge.

Example use to-do every package:

```bash
$ ./bin/unprotect
```

### update-mrconfig: Update known repos

To update `../mrconfig`, which contains a list of all known repositories:

```bash
$ ./bin/update-mrconfig
```
