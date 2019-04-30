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

Inside a package directory, run `./bin/update-control`.
A example todo all the packages (using `setup-team-repos`):

```
~/kali/packages$ for x in $(ls -1); do cd ${x}; ../../tools/packaging/bin/update-control; cd ../; done
```
