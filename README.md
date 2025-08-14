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
podman run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix:rw --env=DISPLAY ghcr.io/otterworks/xfoil
```
Alternatively, `input.xfoil` demonstrates a scripted session with file IO
(without graphics). The workflow boils down to:
```
cat input.xfoil
podman run --rm -v $PWD:/tmp/work:rw ghcr.io/otterworks/xfoil < input.xfoil | tee -a output.xfoil
open plot.ps
```
_____________
This container was inspired somewhat by `docker-xfoil` by [thomaseizinger] & its fork by [rtcameron].
I've started over with a newer, smaller base image^[Here we use Debian-slim instead of Ubuntu 18.04.],
avoided compiling & running `osgen` entirely, and patched the `Makefile`s a bit 
differently^[One of the changes separates `make` from `make install`, for a more familiar experience.]. 
_____________
[XFOIL]: https://web.mit.edu/drela/Public/web/xfoil/
[tgz]: https://web.mit.edu/drela/Public/web/xfoil/xfoil6.99.tgz

[thomaseizinger]: https://github.com/thomaseizinger/docker-xfoil
[rtcameron]: https://github.com/rtcameron/docker-xfoil
