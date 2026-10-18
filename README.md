<div align="center">

<img src="https://github.com/AbyssWM.png?size=200" width="140" alt="AbyssWM logo">

# 🌊 Abyss for Gentoo

**Source overlay for the Abyss Wayland ecosystem (17 packages)**

![Gentoo](https://img.shields.io/badge/Gentoo-overlay-54487A?logo=gentoo&logoColor=white) ![Keyword](https://img.shields.io/badge/keyword-~amd64-orange) ![Native build](https://img.shields.io/badge/native%20build-17%2F17%20passed-brightgreen) ![Session tests](https://img.shields.io/badge/session%20%2F%20hardware%20tests-pending-lightgrey) ![License](https://img.shields.io/badge/recipes-0BSD-blue)

[Website](https://abysswm.github.io) · [Getting started](https://abysswm.github.io/wiki/getting-started) · [Organization](https://github.com/AbyssWM)

</div>

---

Independent overlay, not part of Gentoo's official tree. Everything is built from source; no Abyss binary server is needed. The overlay inherits the `gentoo` repository and all packages use the testing keyword `~amd64`.

## 🚀 Installation

**1. Add the overlay** (needs `app-eselect/eselect-repository` and `dev-vcs/git`):

```sh
eselect repository add abyss git https://github.com/AbyssWM/gentoo-builds.git
emaint sync -r abyss
```

**2. Accept the testing keyword** for the Abyss packages (some dependencies may need `~amd64` too, Portage will tell you):

```sh
# /etc/portage/package.accept_keywords/abyss
dev-libs/abyssutils ~amd64
dev-util/abyss-scanner ~amd64
dev-libs/abyssland-protocols ~amd64
dev-libs/abyssparse ~amd64
dev-libs/abysswire ~amd64
dev-libs/abyssgraphics ~amd64
dev-libs/abyssal ~amd64
dev-libs/abysstoolkit ~amd64
dev-libs/abysscursor ~amd64
gui-wm/abyssland ~amd64
gui-apps/abyss-guiutils ~amd64
gui-libs/xdg-desktop-portal-abyss ~amd64
gui-apps/abysspicker ~amd64
gui-apps/abyssdusk ~amd64
gui-apps/abysspaper ~amd64
gui-apps/abysslock ~amd64
gui-apps/abysspolkit ~amd64
```

**3. Review the plan and install:**

```sh
emerge --ask --pretend gui-wm/abyssland
emerge --ask gui-wm/abyssland
```

Optional companions: `gui-apps/abysslock`, `gui-apps/abysspaper`, `gui-apps/abysspicker`, `gui-apps/abyssdusk`, `gui-apps/abysspolkit`, `gui-apps/abyss-guiutils`, `gui-libs/xdg-desktop-portal-abyss`.

Then continue with the [getting-started guide](https://abysswm.github.io/wiki/getting-started).

## 📦 Packages

| Package | Category | Version | Description |
|---|---|---|---|
| `dev-libs/abyssutils` | Library | 0.14.2 | Utility library for the Abyss ecosystem |
| `dev-util/abyss-scanner` | Tool | 0.4.5 | C++ Wayland protocol scanner for Abyss |
| `dev-libs/abyssland-protocols` | Library | 0.7.0 | Wayland protocol extensions for Abyss |
| `dev-libs/abyssparse` | Library | 0.6.8 | Configuration parsing library for Abyss |
| `dev-libs/abysswire` | Library | 0.3.1 | IPC wire protocol library and scanner for Abyss |
| `dev-libs/abyssgraphics` | Library | 0.5.1 | Graphics and resource library for Abyss |
| `dev-libs/abyssal` | Library | 0.15.0 | Rendering and display backend library for Abyss |
| `dev-libs/abysstoolkit` | Library | 0.6.0 | Native graphical toolkit and config preprocessor for Abyss |
| `dev-libs/abysscursor` | Library | 0.1.13 | Cursor library and theme tools for Abyss |
| `gui-wm/abyssland` | Compositor | 0.56.2 | Dynamic tiling Wayland compositor with C++ configuration |
| `gui-apps/abyss-guiutils` | Application | 0.2.2 | Dialogs and application tools for Abyss |
| `gui-libs/xdg-desktop-portal-abyss` | Desktop integration | 1.4.1 | Desktop portal and screen sharing picker for Abyss |
| `gui-apps/abysspicker` | Application | 0.4.7 | Wayland color picker for Abyss |
| `gui-apps/abyssdusk` | Application | 0.4.0 | Display color temperature manager for Abyss |
| `gui-apps/abysspaper` | Application | 0.8.4 | Wallpaper manager for Abyss |
| `gui-apps/abysslock` | Application | 0.9.6 | Wayland session lock for Abyss |
| `gui-apps/abysspolkit` | Application | 0.2.0 | Polkit authentication agent for Abyss |

Libraries expose ABI subslots. The compositor compiles the public default config and uses an explicitly checksummed Glaze 7.2.0 source archive; the packager's personal configuration is never compiled in.

## ✅ Status

Honest state as of 2026-10-17/18:

- **Built natively:** all 17 packages built with real Portage inside a private official Gentoo stage3 (amd64, glibc) using `unshare --map-auto`. `dev-libs/abyssparse-0.6.8_p20261017-r1` (license revision) was built and installed separately; its `LICENSE`, `COPYING` and `COPYRIGHT` files land in `/usr/share/doc/abyssparse-0.6.8_p20261017-r1/` and are byte-identical to the source.
- **Overlay consistency:** all 17 ebuild/Manifest entries match `sources.json` (commits and hashes); `emerge -p` of all packages gives a clean plan.
- **Not tested:** booted Gentoo desktop session, real hardware, authentication (lock screen, polkit), other architectures, `~amd64`-less (stable) systems. Upstream test suites are not run in the ebuilds.
- The upstream attribution audit remains a separate release prerequisite.

## 🛠️ Maintainer tools

<details>
<summary>Regeneration and private-root validation</summary>

`sources.json` records exact source commits and checksums. Each package has a Manifest and maintainer metadata.

`python3 tools/generate.py` regenerates this overlay. For isolated validation, `tools/build.py` can run real Portage inside a prepared private Gentoo stage3 using Bubblewrap. It requires an explicit `.abyss-private-buildroot` marker; it does not bootstrap Gentoo or change the host system. Test-root setup must account for the single-user namespace and provide its package/USE configuration. `--map-auto` uses already configured subordinate UID/GID ranges through `unshare` and the standard rootless mapping helpers. This permits real service-account ownership inside the private root. It requires working newuidmap/newgidmap and does not create or change host accounts. A single-UID namespace alone cannot install dependencies which need other service users/groups.

```sh
python3 tools/build.py /path/to/private-stage3 --logs out/logs --pretend
python3 tools/build.py /path/to/private-stage3 --logs out/logs
```

</details>

## 📄 License

Maintainer: bb8TheRobot <bb8therobot85@gmail.com>. Packaging code: 0BSD. The sources retain their own licenses and copyright notices, including Abyssparse's LGPL-3.0-only. License scope and retained upstream notices: [LICENSES.md](LICENSES.md).
