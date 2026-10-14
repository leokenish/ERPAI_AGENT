#!/usr/bin/env python3
"""Read-only validation of this conversation extraction package; no network calls."""
from pathlib import Path
from urllib.parse import urlsplit, unquote
from collections import Counter
from datetime import datetime, timezone
import argparse
import hashlib
import json
import re
import zipfile

PROJECT = "kbs-erp-mcp-telegram"
PREVIOUS_HASH = "ced538fd3340bf165fb4e68237ca40dccbac33f5b1542f78ee55b3c5c34f7f7b"
MAP_NODES = {"sap", "export", "git", "knowledge", "codex", "diag", "maps",
             "feedback", "agent", "lookup", "hub", "worker", "expert",
             "telegram", "erp-api", "portal"}
MESSAGE_FIELDS = {"id", "sequence", "role", "timestamp", "content_type",
                  "content_markdown", "source_locator", "redacted", "asset_ids"}
EPISODE_FIELDS = {"id", "order", "title", "goal", "map_nodes", "prerequisites",
                  "message_refs", "commentary_markdown", "outcome_markdown",
                  "exercise_markdown", "asset_ids"}
ASSET_FIELDS = {"id", "original_filename", "path", "kind", "description",
                "availability", "version", "related_message_ids"}

def require(condition, message):
    if not condition:
        raise ValueError(message)

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", nargs="?", default=str(Path(__file__).resolve().parents[2]))
    parser.add_argument("--zip", dest="archive")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    doc = json.loads((root / "conversation-data.json").read_text(encoding="utf-8"))
    require(set(doc) == {"schema_version", "project_id", "project_title", "coverage",
                         "threads", "episodes", "assets"}, "Unexpected top-level schema")
    require(doc["schema_version"] == "1.0" and doc["project_id"] == PROJECT, "Project/schema mismatch")
    require(doc["coverage"]["status"] == "partial" and doc["coverage"]["missing"], "Missing coverage limitations")
    messages = [m for t in doc["threads"] for m in t["messages"]]
    mids = {m["id"] for m in messages}
    aids = {a["id"] for a in doc["assets"]}
    entities = doc["threads"] + messages + doc["episodes"] + doc["assets"]
    ids = [x["id"] for x in entities]
    require(len(ids) == len(set(ids)), "Duplicate ID across entities")
    by_id = {m["id"]:m for m in messages}
    assets = {a["id"]:a for a in doc["assets"]}
    for t in doc["threads"]:
        require(set(t) == {"id","title","source_description","messages"}, "Thread fields")
        require([m["sequence"] for m in t["messages"]] == list(range(1, len(t["messages"])+1)),
                "Sequence is not strictly consecutive in retained display order")
        for m in t["messages"]:
            require(set(m) == MESSAGE_FIELDS, "Message fields: "+m["id"])
            require(m["role"] in {"user","assistant"}, "Message role")
            require(m["content_type"] in {"verbatim","excerpt","summary"}, "Content type")
            require(isinstance(m["redacted"], bool), "Redaction flag")
            require(bool(m["content_markdown"]) and bool(m["source_locator"]), "Missing text/source")
            require(set(m["asset_ids"]) <= aids, "Unknown message asset")
            if m["timestamp"] is not None:
                ts = datetime.fromisoformat(m["timestamp"].replace("Z","+00:00"))
                require(ts.tzinfo is not None, "Timestamp missing timezone")
    require([e["order"] for e in doc["episodes"]] == list(range(1,len(doc["episodes"])+1)), "Episode order")
    covered = set()
    for e in doc["episodes"]:
        require(set(e) == EPISODE_FIELDS, "Episode fields")
        require(set(e["map_nodes"]) <= MAP_NODES, "Unknown map node")
        require(set(e["message_refs"]) <= mids, "Unknown episode message")
        require(set(e["asset_ids"]) <= aids, "Unknown episode asset")
        positions = [by_id[i]["sequence"] for i in e["message_refs"]]
        require(positions == sorted(set(positions)), "Episode reading order/duplicate")
        require("교육용 재작성 프롬프트" in e["exercise_markdown"], "Unlabelled exercise")
        require("교육 해설" in e["commentary_markdown"], "Unlabelled commentary")
        covered.update(e["message_refs"])
    require(covered == mids, "Retained message omitted from all learning sections")
    included = []
    for a in doc["assets"]:
        require(set(a) == ASSET_FIELDS, "Asset fields")
        require(a["kind"] in {"image","code","document","archive","other"}, "Asset kind")
        require(set(a["related_message_ids"]) <= mids, "Unknown asset message")
        if a["availability"] == "unavailable":
            require(a["path"] is None, "Unavailable asset with non-null path")
            require(a["version"] is None, "Unknown original with asserted version")
        else:
            require(a["availability"] == "included" and isinstance(a["path"],str), "Asset availability")
            path = (root / a["path"]).resolve()
            require(path.is_relative_to(root) and path.is_file(), "Asset path missing/unsafe: "+str(a["path"]))
            included.append(a["path"])
        related = [m["id"] for m in messages if a["id"] in m["asset_ids"]]
        require(related == a["related_message_ids"], "Bidirectional asset-message mismatch: "+a["id"])
    actual_assets = {p.relative_to(root).as_posix() for p in (root/"assets").rglob("*") if p.is_file()}
    require(actual_assets == set(included), "Unregistered/missing file under assets")
    require(len(included) == len(set(included)), "Duplicate included asset path")
    archive_path = root/assets["A001"]["path"]
    require(hashlib.sha256(archive_path.read_bytes()).hexdigest() == PREVIOUS_HASH, "Previous ZIP changed")
    source_hashes = []
    with zipfile.ZipFile(archive_path) as z:
        require(z.testzip() is None, "Previous ZIP CRC")
        require(len(z.infolist()) == 9, "Previous ZIP file count changed")
        for info in z.infolist():
            preserved = root/"assets/previous_extract"/info.filename
            require(preserved.is_file() and preserved.read_bytes() == z.read(info.filename),
                    "Previous source changed: "+info.filename)
            source_hashes.append({"path":preserved.relative_to(root).as_posix(),
                                 "sha256":hashlib.sha256(preserved.read_bytes()).hexdigest()})
    summary_source = (root/assets["A006"]["path"]).read_text(encoding="utf-8")
    for i in range(1,15):
        message = by_id[f"M{i*2:03d}"]
        if i == 3:
            require(message["content_type"] == "excerpt", "M006 must remain excerpt")
            require(message["content_markdown"] == "맞아요. 제가 설명한 MCP 서버만 보면 API 중계 서버가 맞습니다...",
                    "M006 excerpt changed")
            continue
        section = summary_source.split(f"## C{i:02d} — ",1)[1].split("\n## ",1)[0]
        original_summary = re.search(r"^답변 요지: (.+)$",section,re.M).group(1)
        require(message["content_type"] == "summary" and message["content_markdown"] == original_summary,
                "Summary silently rewritten: "+message["id"])
    old_checks = json.loads((root/assets["A009"]["path"]).read_text(encoding="utf-8"))
    require(all(x["status"] == "NOT_RUN" and x["evidence"] is None for x in old_checks["checks"]),
            "Historical runtime verification state changed")
    required = {"00_README.md","01_PROJECT_CONTEXT.md","02_LEARNING_GUIDE.md","conversation-data.json"}
    root_files = {p.name for p in root.iterdir() if p.is_file()}
    require(root_files == required, "Required root file set mismatch")
    file_paths = sorted(p for p in root.rglob("*") if p.is_file())
    links = 0
    secret_patterns = [r"\bsk-[A-Za-z0-9_-]{24,}", r"\bgh[pousr]_[A-Za-z0-9]{24,}",
                       r"\b\d{7,12}:[A-Za-z0-9_-]{30,}",
                       r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"]
    for p in file_paths:
        if p.suffix not in {".md",".json",".txt",".py"}:
            continue
        content = p.read_text(encoding="utf-8")
        require("\ufffd" not in content, "UTF-8 replacement character")
        for pattern in secret_patterns:
            require(not re.search(pattern,content), "Possible credential pattern in "+p.name)
        if p.suffix == ".json":
            json.loads(content)
        if p.suffix == ".md":
            require(len(re.findall(r"^```",content,re.M)) % 2 == 0, "Unbalanced fenced blocks")
            for target in re.findall(r"\[[^\]]*\]\(([^)]+)\)",content):
                parsed = urlsplit(target.strip())
                if parsed.scheme or not parsed.path:
                    continue
                linked = (p.parent/unquote(parsed.path)).resolve()
                require(linked.is_relative_to(root) and linked.is_file(), "Broken markdown link: "+target)
                links += 1
    guide = (root/"02_LEARNING_GUIDE.md").read_text(encoding="utf-8")
    for e in doc["episodes"]:
        for n in range(1,12):
            require(f"### {e['id']}.{n} " in guide, "Learning guide missing required section")
    result = {
        "project_id": PROJECT, "package_version": "2.0.0",
        "checked_at": datetime.now(timezone.utc).isoformat(),
        "result": "PASS", "scope": "Extraction data/files only; no ERP, MCP, AI or Telegram runtime executed",
        "counts": {"threads":len(doc["threads"]),"message_records":len(messages),
                   "content_types":dict(Counter(m["content_type"] for m in messages)),
                   "episodes":len(doc["episodes"]),"included_assets":len(included),
                   "unavailable_assets":len(doc["assets"])-len(included),
                   "package_files":len(file_paths),"markdown_relative_links":links},
        "checks": ["utf8_json_parse","required_fields","unique_ids","message_sequence",
                   "episode_reference_order","all_retained_messages_linked","map_nodes",
                   "bidirectional_asset_references","included_paths","unavailable_nulls",
                   "previous_zip_sha256","previous_files_byte_identical",
                   "summary_matches_source","excerpt_preserved","runtime_NOT_RUN_preserved",
                   "required_markdown_sections","markdown_links","fenced_blocks","credential_pattern_scan"],
        "limitations": ["Verbatim text manually transcribed from visible conversation; no platform export available",
                       "Timestamps other than M034 are deliberately null",
                       "Mermaid blocks not rendered; source syntax visually reviewed",
                       "Credential pattern scan is supplemented by manual review",
                       "This PASS is not ERP or bot runtime verification"],
        "runtime_tests": "NOT_RUN", "redaction_count":sum(m["redacted"] for m in messages),
        "previous_archive_sha256":PREVIOUS_HASH,"preserved_files":source_hashes,
        "archive_verification_note": "This saved report records folder validation. The final ZIP is checked separately with --zip to avoid self-referential hashes."
    }
    if args.archive:
        archive = Path(args.archive).resolve()
        with zipfile.ZipFile(archive) as z:
            require(z.testzip() is None,"Delivery ZIP CRC failed")
            expected = {root.name+"/"+p.relative_to(root).as_posix() for p in file_paths}
            require(set(z.namelist()) == expected,"Delivery ZIP file set/root mismatch")
            for p in file_paths:
                require(z.read(root.name+"/"+p.relative_to(root).as_posix()) == p.read_bytes(),
                        "Delivery ZIP bytes mismatch")
        result["checks"].append("delivery_zip_crc_paths_and_bytes")
        result["delivery_zip"] = {"status":"PASS","files":len(file_paths),
                                  "sha256":hashlib.sha256(archive.read_bytes()).hexdigest()}
    print(json.dumps(result,ensure_ascii=False,indent=2))

if __name__ == "__main__":
    main()

