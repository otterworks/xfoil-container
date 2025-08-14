# XFOIL Container

This is simply a containerized build of [XFOIL], currently at version 6.99.
It starts from `alpine`, then installs the fortran compiler and other build
tools before downloading the source from the [official link][tgz].
It then applies a patch to select appropriate compiler flags and adjust file
paths before compiling `xfoil` and its companion programs.

## quick-start
You do not need to clone this repository to use `xfoil`,
you only need the container.
If you use the convenience wrapper from somewhere in your `$PATH`,
then `podman` or `docker` will take care of the rest for you.

```
curl -#SLO --output-dir $HOME/.local/bin https://raw.githubusercontent.com/otterworks/xfoil-container/refs/heads/main/xfoil
cat $HOME/.local/bin/xfoil # *always* inspect a script from the internet before executing it
chmod +x $HOME/.local/bin/xfoil
xfoil
```

## running with other options

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

## troubleshooting

### X authorization

> When I run with graphics enabled, the first operating point I try to analyze causes `xfoil` to abort.

It looks something like this:
```
.OPERi   c>  ALFA 4
 Calculating unit vorticity distributions ...
Authorization required, but no authorization protocol specified

 Cannot open display...aborting

```

The problem is that the current user is not authorized for the X display/socket. The solution is to run:
```
xhost +local:$(whoami)
```
and run the container again.

## endmatter
_____________
This container was inspired somewhat by `docker-xfoil` by [thomaseizinger] & its fork by [rtcameron].
I've started over with a newer, smaller base image[^b], avoided compiling & running `osgen` entirely,
and patched the `Makefile`s a bit differently[^m].
_____________

[^b]: Here we use alpine instead of Ubuntu 18.04 (LTS). With the [multi-stage build][multi-stage], this produces an image that is only 17.3 MB.
[^m]: One of the changes separates `make` from `make install`, for a more familiar experience. I may try migrating all the `Makefile`s to autotools or CMake sometime later. (Actually, it looks like [someone has already packaged Xfoil 6.97 with CMake][robotlocomotion],so I could fork from that if I wanted.)
_____________
[XFOIL]: https://web.mit.edu/drela/Public/web/xfoil/
[tgz]: https://web.mit.edu/drela/Public/web/xfoil/xfoil6.99.tgz

[thomaseizinger]: https://github.com/thomaseizinger/docker-xfoil
[rtcameron]: https://github.com/rtcameron/docker-xfoil
[robotlocomotion]: https://github.com/RobotLocomotion/xfoil
[multi-stage]: https://blog.lazkani.io/posts/multi-stage-docker-container-build/
