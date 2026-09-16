#!/usr/bin/env bash
# find-note.sh — Resolve o caminho físico de uma nota por nome de arquivo ou alias.
#
# Substitui o "lazy-read" por tentativa de leitura/grep (que casa com menções
# dentro de outras notas e gera falso positivo). Busca determinística e sem
# listar diretórios: apenas o resultado entra no contexto.
#
# Uso:
#   scripts/find-note.sh "Cullen"
#   scripts/find-note.sh "O Tolo"
#
# Código de saída: 0 = encontrado, 1 = não existe, 2 = erro de uso.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT="${LOTM_VAULT:-$(cd "$SCRIPT_DIR/../../../.." && pwd)}"
TERM="${1:-}"

if [ -z "$TERM" ]; then
  echo "uso: find-note.sh <nome|alias>" >&2
  exit 2
fi

python3 - "$VAULT" "$TERM" <<'PY'
import os
import sys
import unicodedata

VAULT, TERM = sys.argv[1], sys.argv[2]
SKIP_DIRS = {".git", ".obsidian", ".agents"}


def norm(text):
    text = unicodedata.normalize("NFKD", text)
    text = "".join(c for c in text if not unicodedata.combining(c))
    return text.casefold().strip()


def parse_aliases(front):
    aliases = []
    match = None
    for line in front.split("\n"):
        if line.startswith("aliases:"):
            inline = line.split(":", 1)[1].strip()
            if inline.startswith("[") and inline.endswith("]"):
                aliases += [x.strip().strip("\"'") for x in inline.strip("[]").split(",")]
            match = True
        elif match and line.strip().startswith("-"):
            aliases.append(line.split("-", 1)[1].strip().strip("\"'").split(" #")[0].strip())
        elif match and line.strip() and not line.startswith((" ", "\t")):
            match = None
    return [a for a in aliases if a]


entries = []
for dirpath, dirnames, filenames in os.walk(VAULT):
    dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
    for name in filenames:
        if not name.endswith(".md"):
            continue
        path = os.path.join(dirpath, name)
        with open(path, encoding="utf-8", errors="ignore") as handle:
            text = handle.read()
        front = text[3:text.find("\n---", 3)] if text.startswith("---") else ""
        entries.append(
            (
                os.path.relpath(path, VAULT),
                os.path.splitext(name)[0],
                parse_aliases(front),
            )
        )

def stem(text):
    """Normaliza singular/plural para evitar falso 'NAO ENCONTRADA'."""
    return " ".join(
        w[:-1] if len(w) > 3 and w.endswith("s") else w for w in norm(text).split()
    )


needle = norm(TERM)
exact, by_alias, partial, by_stem = [], [], [], []
for rel, base, aliases in entries:
    if norm(base) == needle:
        exact.append((rel, base, None))
    for alias in aliases:
        if norm(alias) == needle:
            by_alias.append((rel, base, alias))
    if needle and (needle in norm(base) or any(needle in norm(a) for a in aliases)):
        partial.append((rel, base, None))
    stemmed = stem(TERM)
    if stemmed and (
        stemmed in stem(base) or any(stemmed in stem(a) for a in aliases)
    ):
        by_stem.append((rel, base, None))

hits = exact or by_alias or partial or by_stem
if not hits:
    print(f"NAO ENCONTRADA: {TERM}")
    sys.exit(1)

for rel, base, alias in hits:
    extra = f"   (via alias \"{alias}\" — link correto: [[{base}|{alias}]])" if alias else ""
    print(f"{rel}{extra}")
sys.exit(0)
PY
