#!/usr/bin/env python3
"""Build recipes using Portage in an explicitly marked private Gentoo root."""

import argparse
import json
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("buildroot", type=Path)
parser.add_argument("packages", nargs="*")
parser.add_argument("--logs", type=Path, required=True)
parser.add_argument("--pretend", action="store_true")
parser.add_argument("--map-auto", action="store_true", help="use configured subordinate UID/GID ranges for real package ownership")
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
buildroot = args.buildroot.resolve()
if buildroot == Path("/") or not (buildroot / ".abyss-private-buildroot").is_file():
    parser.error("buildroot must have the explicit .abyss-private-buildroot marker")
catalog = json.loads((root / "catalog.json").read_text())
sources = json.loads((root / "sources.json").read_text())
packages = [catalog["packages"][source["repo"]] for source in sources["packages"]]
if args.packages:
    unknown = set(args.packages) - {package["name"] for package in packages}
    if unknown:
        parser.error(f"unknown packages: {sorted(unknown)}")
    packages = [package for package in packages if package["name"] in args.packages]
args.logs.mkdir(parents=True, exist_ok=True)
command = ["bwrap", "--unshare-user", "--uid", "0", "--gid", "0",
           "--bind", str(buildroot), "/", "--proc", "/proc", "--dev", "/dev",
           "--ro-bind", "/sys", "/sys", "--ro-bind", "/etc/resolv.conf", "/etc/resolv.conf",
           "--ro-bind", str(root), "/overlay", "/usr/bin/env", "-i",
           "PATH=/usr/sbin:/usr/bin:/sbin:/bin", "HOME=/root", "LANG=C.UTF-8",
           "/usr/bin/emerge", "--getbinpkg", "--usepkg", "--oneshot"]
if args.map_auto:
    command.remove("--unshare-user")
    capabilities = ["CAP_CHOWN", "CAP_DAC_OVERRIDE", "CAP_FOWNER", "CAP_FSETID", "CAP_SETUID", "CAP_SETGID"]
    for capability in capabilities:
        command[1:1] = ["--cap-add", capability]
    command = ["unshare", "--map-auto", "--map-root-user"] + command
if args.pretend:
    command += ["--pretend"]
    targets = ["all"]
else:
    targets = [package["name"] for package in packages]
receipt = []
for target in targets:
    selected = packages if args.pretend else [package for package in packages if package["name"] == target]
    atoms = [f'{package["category"]}/{package["name"]}' for package in selected]
    log = args.logs / (target + ".log")
    print(f'{"Resolving" if args.pretend else "Building"} {target}; log: {log}', flush=True)
    with log.open("w") as output:
        result = subprocess.run(command + atoms, stdout=output, stderr=subprocess.STDOUT)
    receipt.append({"package": target, "pretend": args.pretend,
                    "subordinate_uid_mapping": args.map_auto,
                    "exit_code": result.returncode, "log": log.name})
    (args.logs / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
    if result.returncode:
        print("FAILED\n" + "\n".join(log.read_text().splitlines()[-25:]), flush=True)
        raise SystemExit(result.returncode)
    print(f'Completed {target}', flush=True)
