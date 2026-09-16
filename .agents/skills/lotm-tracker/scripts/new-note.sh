#!/usr/bin/env bash
# new-note.sh — Cria uma nota já no formato canônico (frontmatter + esqueleto),
# a partir do template da skill, roteada para a pasta correta.
#
# Elimina a necessidade de ler todos os templates a cada capítulo: o agente
# chama o script e recebe apenas o esqueleto da entidade que vai criar.
#
# Uso:
#   scripts/new-note.sh <tipo> "<Nome>"
#   scripts/new-note.sh resumo <numero> "<título do capítulo>"
#
# Tipos: personagem, personagem-moc, personagem-moc-arquivado, artefato,
#        organizacao, deus, local-geopolitico, ponto-de-interesse, lore,
#        caminho, sequencia, ingrediente, era, evento, resumo
#
# Nunca sobrescreve arquivo existente. Código de saída: 0 = criado, 1 = existe,
# 2 = erro de uso.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
VAULT="${LOTM_VAULT:-$(cd "$SCRIPT_DIR/../../../.." && pwd)}"
TEMPLATES="$SKILL_DIR/references/templates"

TYPE="${1:-}"
NAME="${2:-}"
TITLE="${3:-}"

if [ -z "$TYPE" ] || [ -z "$NAME" ]; then
  echo "uso: new-note.sh <tipo> \"<Nome>\"   |   new-note.sh resumo <numero> \"<título>\"" >&2
  exit 2
fi

case "$TYPE" in
  personagem)                DIR="personagens" ;;
  personagem-moc)            DIR="personagens" ;;
  personagem-moc-arquivado)  DIR="personagens" ;;
  artefato)                  DIR="artefatos" ;;
  organizacao)               DIR="organizacoes" ;;
  deus)                      DIR="deuses" ;;
  local-geopolitico)         DIR="locais/geopolitica" ;;
  ponto-de-interesse)        DIR="locais/pontos_interesse" ;;
  lore)                      DIR="lore" ;;
  caminho)                   DIR="beyonders/caminhos" ;;
  sequencia)                 DIR="beyonders/sequencias" ;;
  ingrediente)               DIR="beyonders/ingredientes" ;;
  era)                       DIR="historia/eras" ;;
  evento)                    DIR="historia/eventos" ;;
  resumo)                    DIR="resumos" ;;
  *)
    echo "tipo inválido: $TYPE" >&2
    echo "tipos: personagem, personagem-moc, personagem-moc-arquivado, artefato, organizacao, deus, local-geopolitico, ponto-de-interesse, lore, caminho, sequencia, ingrediente, era, evento, resumo" >&2
    exit 2
    ;;
esac

TEMPLATE="$TEMPLATES/$TYPE.md"
if [ ! -f "$TEMPLATE" ]; then
  echo "template ausente: $TEMPLATE" >&2
  exit 2
fi

if [ "$TYPE" = "resumo" ]; then
  if [ -z "$TITLE" ]; then
    echo "resumo exige número e título: new-note.sh resumo 131 \"título do capítulo\"" >&2
    exit 2
  fi
  CHAPTER="$(printf '%04d' "$((10#$NAME))")"
  SLUG="$(printf '%s' "$TITLE" | tr '[:upper:]' '[:lower:]')"
  REL="$DIR/$CHAPTER - $SLUG.md"
else
  REL="$DIR/$NAME.md"
fi

TARGET="$VAULT/$REL"
if [ -e "$TARGET" ]; then
  echo "JÁ EXISTE (nada foi escrito): $REL" >&2
  exit 1
fi

mkdir -p "$(dirname "$TARGET")"

python3 - "$TEMPLATE" "$TARGET" "$NAME" "$TITLE" "${CHAPTER:-}" <<'PY'
import re
import sys

template_path, target_path, name, title, chapter = sys.argv[1:6]
with open(template_path, encoding="utf-8") as handle:
    text = handle.read()

text = text.replace("[Nome]", name)
if title:
    text = text.replace("[Título do Capítulo]", title)
    text = text.replace("[Número de 4 casas]", chapter)

# Descarta aliases-exemplo do template ("- [Outros nomes...]") e remove a
# chave `aliases:` se nada de real restar. O agente preenche depois.
lines = text.split("\n")
out, i = [], 0
while i < len(lines):
    line = lines[i]
    if re.match(r"^aliases:[ \t]*$", line):
        j, kept = i + 1, []
        while j < len(lines) and re.match(r"^\s+-\s", lines[j]):
            if not re.search(r"\[[^\]]*\]", lines[j]):
                kept.append(lines[j])
            j += 1
        if kept:
            out.append(line)
            out.extend(kept)
        i = j
        continue
    out.append(line)
    i += 1
text = "\n".join(out)

with open(target_path, "w", encoding="utf-8") as handle:
    handle.write(text)

comments = text.count("<!--")
placeholders = re.findall(r"(?<!\[)\[[^\[\]\n]{1,60}\](?!\])", text)
stubs = re.findall(r"\[\[Seq X[^\]]*\]\]", text)
if comments or placeholders or stubs:
    print(
        f"AVISO: restam {comments} comentário(s), {len(placeholders)} placeholder(s) "
        f"e {len(stubs)} link(s)-exemplo do template — preencha ou remova antes de salvar; "
        "validate.sh acusa resíduos e links fantasmas."
    )
PY

echo "criado: $REL"
