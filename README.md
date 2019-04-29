# Helper tools for Kali packagers

How to checkout all Kali packages at once, assuming that the current
directory is the checkout of this repository:

```
$ mkdir -p ~/kali/packages/
$ ./bin/setup-team-repos ~/kali/packages
I will setup /home/rhertzog/kali/packages/.mrconfig to easily checkout all repositories.
Shall I proceed? [Yn] y
I will run 'mr --force checkout' to clone all repositories.
Shall I proceed? [Yn] y
mr checkout: /home/rhertzog/kali/packages/0trace
[...]
```

You might want to update the `mrconfig` file listing all repositories
just to ensure that it is up-to-date:
```
$ bin/update-mrconfig
```
