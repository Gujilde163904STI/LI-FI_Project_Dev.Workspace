external*pkg*dirs
=================

Test application for the EXTERNAL*PKG*DIRS feature of the buildsystem.
Two external packages are provided in `external*pkgs/`: `external*pkg` and
`external*pkg*not_used`. If the first package is not properly included, a define
from `CFLAGS` is missing and a precompiler error is triggered. If the second
package somehow ends up included it triggers a makefile error.

Usage
=====

Set `EXTERNAL*PKG*DIRS` inside Makefile to point to other paths where the
buildsystem can look for packages. Similar functionality to `EXTERNAL*PKG*DIRS`.
Be careful to not name these externally provided packages the same as existing
packages in `$(RIOTBASE)/pkg/`.
