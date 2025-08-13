# XFOIL Container

This is simply a containerized build of [XFOIL], currently at version 6.99.
It starts from `debian:trixie-slim`, then installs the fortran compiler and
other build tools before downloading the compressed source tarball from the
[official link][tgz]. It then applies a few patches, listed below, to select
appropriate compiler flags and adjust file paths before compiling XFOIL and
its companion programs.

You should be able to get the container image with:
```
podman image pull ghcr.io/otterworks/xfoil
```
and then you can run an interactive session with graphics support:
```
podman run --rm
```
Alternatively, `example.sh` illustrates a scripted session with file IO
(without graphics). It boils down to:
```
podman run --rm 
```

_____________
[XFOIL]: https://web.mit.edu/drela/Public/web/xfoil/
[tgz]: https://web.mit.edu/drela/Public/web/xfoil/xfoil6.99.tgz
