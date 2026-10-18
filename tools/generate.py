#!/usr/bin/env python3
"""Regenerate this distribution's pinned Abyss recipes."""

import json
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[1]


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def gentoo(package, catalog, sources):
    name = package["name"]
    version = package["version"] + "_p" + package.get("snapshot_date", sources["snapshot_date"])
    revision = package.get("gentoo_revision", 0)
    suffix = f"-r{revision}" if revision else ""
    distfile = package.get("gentoo_distfile", "${P}.tar.gz")
    directory = ROOT / package["category"] / name
    deps = [catalog["dependencies"][key]["gentoo"] for key in package["dependencies"]]
    for dependency in package["internal"]:
        target = next(p for p in sources["packages"] if p["name"] == dependency)
        deps.append(f'>={target["category"]}/{dependency}-{target["version"]}:0=')
    deptext = "\n".join("\t" + dependency for dependency in sorted(set(deps)))
    builddeps = ["virtual/pkgconfig"]
    for name_ in package.get("build_dependencies", []):
        builddeps.append(catalog["dependencies"][name_]["gentoo"])
    for name_ in package.get("build_internal", []):
        target = next(p for p in sources["packages"] if p["name"] == name_)
        builddeps.append(f'>={target["category"]}/{name_}-{target["version"]}')
    options = list(package.get("cmake", []))
    runtime = package.get("runtime", {}).get("gentoo", [])
    text = f'''# Copyright 2026 bb8TheRobot
# SPDX-License-Identifier: 0BSD

EAPI=8

inherit {"meson" if package["build_system"] == "meson" else "cmake"}

DESCRIPTION="{package["description"]}"
HOMEPAGE="https://github.com/AbyssWM/{package["repo"]}"
ABYSS_COMMIT="{package["commit"]}"
SRC_URI="https://github.com/AbyssWM/{package["repo"]}/archive/${{ABYSS_COMMIT}}.tar.gz -> {distfile}"
S="${{WORKDIR}}/{package["repo"]}-${{ABYSS_COMMIT}}"

LICENSE="{package["gentoo_license"]}"
SLOT="{"0/" + str(package["soname"]) if package.get("library") else "0"}"
KEYWORDS="~amd64"
'''
    if deps:
        text += f'\nDEPEND="\n{deptext}\n"\n'
        if runtime:
            text += 'RDEPEND="${DEPEND}\n' + "\n".join("\t" + atom for atom in runtime) + '\n"\n'
        else:
            text += 'RDEPEND="${DEPEND}"\n'
    elif runtime:
        text += '\nRDEPEND="' + " ".join(runtime) + '"\n'
    text += '\nBDEPEND="\n' + "\n".join("\t" + atom for atom in sorted(set(builddeps))) + '\n"\n'
    if name == "abyssland":
        extra = sources["extras"]["glaze"]
        text += f'\nSRC_URI+=" {extra["url"]} -> {extra["filename"]}"\n'
    if package.get("patches"):
        text += '\nPATCHES=(\n' + "\n".join(f'\t"${{FILESDIR}}/{patch}"' for patch in package["patches"]) + '\n)\n'
        for patch in package["patches"]:
            directory.joinpath("files").mkdir(parents=True, exist_ok=True)
            shutil.copy2(ROOT / "patches" / package["name"] / patch, directory / "files" / patch)
    if package["build_system"] == "cmake":
        text += '\nsrc_configure() {\n\tlocal mycmakeargs=(\n\t\t-DBUILD_TESTING=OFF\n\t\t-DFETCHCONTENT_FULLY_DISCONNECTED=ON\n'
        text += "".join(f'\t\t{arg}\n' for arg in options)
        if name == "abyssland":
            text += '\t\t-DABYSS_CONFIG="${S}/config.def.hpp"\n\t\t-DFETCHCONTENT_SOURCE_DIR_GLAZE="${WORKDIR}/glaze-7.2.0"\n\t\t-DNO_SYSTEMD=ON\n\t\t-DNO_UWSM=ON\n'
        if name == "abysspaper":
            text += '\t\t-DABYSS_CONFIG_DIR="${WORKDIR}/empty-config"\n'
        text += '\t)\n\tcmake_src_configure\n}\n'
    text += f'\nsrc_install() {{\n\t{package["build_system"]}_src_install\n\tdodoc LICENSE\n'
    if name == "abyssparse":
        text += '\tdodoc COPYING COPYRIGHT\n'
    if name == "abyssland":
        text += '\tnewdoc "${WORKDIR}/glaze-7.2.0/LICENSE" glaze-LICENSE\n'
        # OpenRC has no user session bus, so offer a session that starts its own D-Bus
        text += '\tsed -e "s|^Name=.*|Name=Abyssland (D-Bus)|" -e "s|^Exec=.*|Exec=dbus-run-session /usr/bin/start-abyssland|" \\\n'
        text += '\t\t"${ED}/usr/share/wayland-sessions/abyssland.desktop" \\\n'
        text += '\t\t> "${ED}/usr/share/wayland-sessions/abyssland-dbus.desktop" || die\n'
    text += '}\n'
    write(directory / f"{name}-{version}{suffix}.ebuild", text)
    write(directory / "metadata.xml", f'''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE pkgmetadata SYSTEM "https://www.gentoo.org/dtd/metadata.dtd">
<pkgmetadata>
\t<maintainer type="person">
\t\t<email>{sources["maintainer"]["email"]}</email>
\t\t<name>{sources["maintainer"]["name"]}</name>
\t</maintainer>
\t<upstream>
\t\t<remote-id type="github">AbyssWM/{package["repo"]}</remote-id>
\t</upstream>
</pkgmetadata>
''')
    manifest_distfile = package.get("gentoo_distfile", f"{name}-{version}.tar.gz")
    write(directory / "Manifest", f'DIST {manifest_distfile} {package["size"]} BLAKE2B {package["blake2b"]} SHA512 {package["sha512"]}\n')
    if name == "abyssland":
        extra = sources["extras"]["glaze"]
        with (directory / "Manifest").open("a") as manifest:
            manifest.write(f'DIST {extra["filename"]} {extra["size"]} BLAKE2B {extra["blake2b"]} SHA512 {extra["sha512"]}\n')


def main():
    sources = json.loads((ROOT / "sources.json").read_text())
    catalog = json.loads((ROOT / "catalog.json").read_text())
    for package in sources["packages"]:
        package.update(catalog["packages"][package["repo"]])
    for package in sources["packages"]:
        gentoo(package, catalog, sources)
    write(ROOT / "profiles/categories", "\n".join(sorted({p["category"] for p in sources["packages"]})) + "\n")


if __name__ == "__main__":
    main()
