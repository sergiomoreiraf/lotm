#!/usr/bin/env bash
# validate.sh — Verificação determinística do vault (substitui checklists mentais do LLM).
#
# Uso:
#   scripts/validate.sh            # apenas reporta
#   scripts/validate.sh --fix-tmp  # reporta e remove buffers temporários órfãos
#
# Código de saída: 0 = limpo, 1 = problemas encontrados, 2 = erro de uso.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT="${LOTM_VAULT:-$(cd "$SCRIPT_DIR/../../../.." && pwd)}"

FIX_TMP=0
for arg in "$@"; do
  case "$arg" in
    --fix-tmp) FIX_TMP=1 ;;
    -h|--help)
      echo "uso: validate.sh [--fix-tmp]"
      exit 0
      ;;
    *)
      echo "argumento desconhecido: $arg" >&2
      exit 2
      ;;
  esac
done

if [ ! -d "$VAULT" ]; then
  echo "vault não encontrado: $VAULT" >&2
  exit 2
fi

python3 - "$VAULT" "$FIX_TMP" <<'PY'
import os
import re
import sys
import unicodedata

VAULT = sys.argv[1]
FIX_TMP = sys.argv[2] == "1"

SKIP_DIRS = {".git", ".obsidian", ".agents"}
# Notas de controle cujo H1 difere legitimamente do nome do arquivo.
H1_EXEMPT = {
    "resumos",
    "progresso.md",
    "misterios.md",
    "diario_de_roselle.md",
    "linha_do_tempo.md",
    "moc-geopolitica.md",
    "README.md",
}
# Onde marcadores de capítulo são legítimos (fora de resumos/, são proibidos).
CHAPTER_MARKER_ALLOWED = {"progresso.md"}


def norm(text):
    text = unicodedata.normalize("NFKD", text)
    text = "".join(c for c in text if not unicodedata.combining(c))
    return text.casefold().strip()


def read(path):
    with open(path, encoding="utf-8", errors="ignore") as handle:
        return handle.read()


def strip_code(text):
    """Remove blocos e trechos de código, onde [[links]] são exemplos."""
    text = re.sub(r"```.*?```", "", text, flags=re.S)
    text = re.sub(r"`[^`\n]*`", "", text)
    return text


def parse_frontmatter(text):
    if not text.startswith("---"):
        return ""
    end = text.find("\n---", 3)
    return text[3:end] if end != -1 else ""


def parse_aliases(front):
    aliases = set()
    match = re.search(r"^aliases:[ \t]*(.*)$", front, re.M)
    if not match:
        return aliases
    inline = match.group(1).strip()
    if inline.startswith("[") and inline.endswith("]"):
        for item in inline.strip("[]").split(","):
            item = item.strip().strip("\"'")
            if item:
                aliases.add(norm(item))
        return aliases
    rest = front[match.end():]
    for line in rest.split("\n"):
        if re.match(r"^\s+-\s+", line):
            item = re.sub(r"^\s+-\s+", "", line).strip().strip("\"'")
            item = item.split(" #")[0].strip()
            if item:
                aliases.add(norm(item))
        elif line.strip() and not line.startswith((" ", "\t")):
            break
    return aliases


# ---------------------------------------------------------------- inventário
files = []
for dirpath, dirnames, filenames in os.walk(VAULT):
    dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
    for name in filenames:
        if name.endswith(".md"):
            files.append(os.path.join(dirpath, name))
files.sort()

by_name = {}
for path in files:
    text = read(path)
    front = parse_frontmatter(text)
    base = os.path.splitext(os.path.basename(path))[0]
    by_name.setdefault(norm(base), []).append((path, parse_aliases(front)))

alias_owner = {}
for name, entries in by_name.items():
    for path, aliases in entries:
        for alias in aliases:
            alias_owner.setdefault(alias, (path, name))


def rel(path):
    return os.path.relpath(path, VAULT)


def exempt(path, names):
    parts = rel(path).split(os.sep)
    return parts[0] in names or parts[-1] in names


# ---------------------------------------------------------------- verificações
ghosts = []
alias_links = []
markers = []
headings = []
comments = []

for path in files:
    raw = read(path)
    text = strip_code(raw)
    body_start = raw.find("\n---", 3)
    body = raw[body_start + 4:] if body_start != -1 else raw

    for target in re.findall(r"\[\[([^\]\|#]+)(?:\|[^\]]*)?\]\]", text):
        target = target.strip()
        if not target:
            continue
        if norm(target) in by_name:
            continue
        if norm(target) in alias_owner:
            owner_path, owner_name = alias_owner[norm(target)]
            alias_links.append(
                (rel(path), target, os.path.splitext(os.path.basename(owner_path))[0])
            )
        else:
            ghosts.append((rel(path), target))

    if not exempt(path, CHAPTER_MARKER_ALLOWED) and not rel(path).startswith(
        "resumos" + os.sep
    ):
        for line_no, line in enumerate(body.split("\n"), start=1):
            if re.search(r"\bCap[ií]tulo\s+\d+", line):
                markers.append((rel(path), line_no, line.strip()[:90]))

    if not exempt(path, H1_EXEMPT):
        match = re.search(r"^#\s+(.+)$", body, re.M)
        if match:
            h1 = match.group(1).strip()
            base = os.path.splitext(os.path.basename(path))[0]
            front = parse_frontmatter(raw)
            aliases = parse_aliases(front)
            if norm(h1) != norm(base) and norm(h1) not in aliases:
                headings.append((rel(path), h1))

    for line_no, line in enumerate(raw.split("\n"), start=1):
        if "<!--" in line:
            comments.append((rel(path), line_no, line.strip()[:90]))


# cobertura de resumos
missing_resumos = []
progress = os.path.join(VAULT, "progresso.md")
if os.path.exists(progress):
    match = re.search(r"Cap[ií]tulo\s+(\d+)", read(progress))
    if match:
        last = int(match.group(1))
        present = set()
        for name in os.listdir(os.path.join(VAULT, "resumos")):
            num = re.match(r"^(\d{4})\s*-\s*", name)
            if num:
                present.add(int(num.group(1)))
        # A numeração começa onde o acervo de resumos começa: lacunas antes
        # do primeiro resumo existente são política antiga, não erro.
        first = min(present) if present else 1
        missing_resumos = [n for n in range(first, last + 1) if n not in present]

# buffers temporários
tmp_dir = os.path.join(VAULT, ".agents", "tmp")
stale_tmp = []
if os.path.isdir(tmp_dir):
    stale_tmp = sorted(
        os.path.join(tmp_dir, f) for f in os.listdir(tmp_dir) if f.endswith(".md")
    )

if FIX_TMP:
    for path in stale_tmp:
        os.remove(path)

# ---------------------------------------------------------------- relatório
problems = 0


def section(title, rows, render, fixable=False):
    global problems
    if not rows:
        print(f"  ok   {title}")
        return
    problems += len(rows)
    suffix = " (removidos com --fix-tmp)" if fixable else ""
    print(f"  ERRO {title}: {len(rows)}{suffix}")
    for row in rows[:25]:
        print(f"         {render(row)}")
    if len(rows) > 25:
        print(f"         ... e mais {len(rows) - 25}")


print(f"validate.sh — vault: {VAULT}")
print(f"notas indexadas: {len(files)}\n")

section("Links fantasmas ([[Nota]] sem arquivo)", ghosts, lambda r: f"{r[1]}  em  {r[0]}")
section(
    "Links via alias direto (use [[Real|Alias]])",
    alias_links,
    lambda r: f"[[{r[1]}]] -> [[{r[2]}|{r[1]}]]  em  {r[0]}",
)
section(
    "Marcadores de capítulo proibidos",
    markers,
    lambda r: f"{r[0]}:{r[1]}  {r[2]}",
)
section(
    "H1 divergente do arquivo e ausente em aliases",
    headings,
    lambda r: f"{r[1]}  em  {r[0]}",
)
section(
    "Comentários HTML residuais (<!-- -->)",
    comments,
    lambda r: f"{r[0]}:{r[1]}  {r[2]}",
)
section(
    "Resumos ausentes até o capítulo processado",
    missing_resumos,
    lambda r: f"capítulo {r:04d}",
)
section(
    "Buffers temporários órfãos em .agents/tmp/",
    [] if FIX_TMP else stale_tmp,
    lambda r: rel(r),
    fixable=True,
)

print()
if problems == 0:
    print("RESULTADO: vault limpo.")
    sys.exit(0)
print(f"RESULTADO: {problems} problema(s).")
sys.exit(1)
PY
