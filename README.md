# Abyss Gentoo builds

Experimental source overlay for all 17 Abyss repositories. This is an independent
overlay, not part of Gentoo's official package tree. Builds are still being
validated. Packages currently use the testing keyword `~amd64`.

Clone this repository into a directory of your choice. Configure Portage's
`repos.conf` to point directly at the checkout root:

```ini
[abyss]
location = /path/to/gentoo-builds
auto-sync = no
```

The overlay inherits the official `gentoo` repository. Enable the testing keyword
for the selected Abyss packages and review the dependency/USE plan before emerging
them. Some current dependencies also require testing keywords. All packages are
built from source; no Abyss binary package server is required.

`sources.json` records exact source commits and checksums. Each package has a
Manifest and maintainer metadata. Libraries expose ABI subslots. The compositor
compiles the public default config and uses an explicitly checksummed Glaze 7.2.0
source archive; the packager's personal configuration is never compiled in.

`python3 tools/generate.py` regenerates this overlay. For isolated validation,
`tools/build.py` can run real Portage inside a prepared private Gentoo stage3
using Bubblewrap. It requires an explicit `.abyss-private-buildroot` marker;
it does not bootstrap Gentoo or change the host system. Test-root setup must
account for the single-user namespace and provide its package/USE configuration.
`--map-auto` uses already configured subordinate UID/GID ranges through `unshare`
and the standard rootless mapping helpers. This permits real service-account
ownership inside the private root. It requires working newuidmap/newgidmap and
does not create or change host accounts. A single-UID namespace alone cannot
install dependencies which need other service users/groups. A buildroot run
still does not test authentication or a booted Gentoo desktop session.

```sh
python3 tools/build.py /path/to/private-stage3 --logs out/logs --pretend
python3 tools/build.py /path/to/private-stage3 --logs out/logs
```

Maintainer: bb8TheRobot <bb8therobot85@gmail.com>.
Packaging code: 0BSD. The sources retain their own licenses and copyright
notices, including Abyssparse's LGPL-3.0-only. The upstream attribution audit
remains a separate release prerequisite.

License scope and the retained upstream notices are described in [LICENSES.md](LICENSES.md).
