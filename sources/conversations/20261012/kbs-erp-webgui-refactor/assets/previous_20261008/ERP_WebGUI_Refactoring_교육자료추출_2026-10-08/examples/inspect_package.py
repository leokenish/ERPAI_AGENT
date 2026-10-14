#!/usr/bin/env python3
"""2026-10-08 education example: read ZIPs only; no network or file writes.

This checks archived bytes and recorded results, not browser or ERP behavior.
Run from any directory. Python 3 standard library only.
"""
from collections import Counter
from hashlib import sha256
import json
from pathlib import Path, PurePosixPath
from zipfile import ZipFile


ROOT = Path(__file__).resolve().parents[1]
ARCHIVES = ROOT / "attachments"


def read_zip(path):
    with ZipFile(path) as archive:
        names = archive.namelist()
        if len(names) != len(set(names)):
            raise ValueError("Duplicate ZIP members: " + path.name)
        for name in names:
            p = PurePosixPath(name)
            if p.is_absolute() or ".." in p.parts or "\\" in name:
                raise ValueError("Unsafe ZIP member path")
        if archive.testzip() is not None:
            raise ValueError("ZIP CRC failure: " + path.name)
        return {i.filename: archive.read(i) for i in archive.infolist()
                if not i.is_dir()}


def inspect(root=ROOT):
    folder = root / "attachments"
    evidence_path = folder / "ITS_Chrome_v3_Evidence.zip"
    evidence = read_zip(evidence_path)
    manifest = json.loads(evidence["manifest.json"])
    recorded = json.loads(evidence["validation.json"])
    paths = {row["file"] for row in manifest}
    assert len(paths) == len(manifest) == 100
    changed = {row["file"] for row in manifest if row["modifiedThisRound"]}
    assert len(changed) == 33
    observed = {}
    for label, tree, key in (
        ("Full", "modified", "sha256"),
        ("Rollback", "baseline", "baselineSHA256"),
        ("Original", "original", "originalSHA256"),
    ):
        content = read_zip(folder / ("ITS_Chrome_v3_" + label + ".zip"))
        assert set(content) == paths, label + " file set differs"
        for row in manifest:
            name = row["file"]
            assert content[name], "Empty file: " + name
            assert content[name] == evidence[tree + "/" + name], name
            assert sha256(content[name]).hexdigest() == row[key], name
        observed[label] = len(content)
    patch = read_zip(folder / "ITS_Chrome_v3_Apply.zip")
    assert set(patch) == changed, "Apply member set differs"
    for name, content in patch.items():
        assert content == evidence["modified/" + name], name
    observed["Apply"] = len(patch)
    for row in manifest:
        name = row["file"]
        before = evidence["baseline/" + name]
        after = evidence["modified/" + name]
        original = evidence["original/" + name]
        assert (before != after) == row["modifiedThisRound"], name
        assert (original != after) == row["modifiedFromOriginal"], name
    all_types = Counter(PurePosixPath(p).suffix for p in paths)
    changed_types = Counter(PurePosixPath(p).suffix for p in changed)
    assert all_types == {".js": 47, ".css": 34, ".html": 19}
    assert changed_types == {".js": 16, ".css": 3, ".html": 14}
    # A stored count is evidence of the historical run, not a new test run.
    stored_cases = sum(recorded["cases"].values())
    assert stored_cases == 186
    return {
        "archives": observed,
        "evidence_members": len(evidence),
        "file_types": dict(all_types),
        "changed_types": dict(changed_types),
        "stored_mock_cases_not_rerun": stored_cases,
        "modified_from_original": sum(r["modifiedFromOriginal"] for r in manifest),
        "crc_hashes_and_version_contents_agree": True,
        "archive_sha256": {p.name: sha256(p.read_bytes()).hexdigest()
                           for p in sorted(folder.glob("*.zip"))},
    }


if __name__ == "__main__":
    result = inspect()
    print("Full: 100 / Apply: 33 / Rollback: 100 / Original: 100")
    print("JS: 47 / CSS: 34 / HTML: 19")
    print("Changed from baseline: 33 (JS 16 / CSS 3 / HTML 14)")
    print("Stored mock cases: 186 (not executed by this script)")
    print("PASS: ZIP CRC, member paths, manifest hashes and version contents agree.")
