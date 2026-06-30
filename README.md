# Lord of the Mysteries - Caderno de Leitura

Este repositório é um cofre do **Obsidian** estruturado como um caderno de leitura pessoal e assistido por IA para a web novel _Lord of the Mysteries_.

## 📁 Estrutura do Vault

- `personagens/` — Notas e MOCs de personagens.
- `artefatos/` — Itens místico-selados e efeitos.
- `deuses/` — Divindades.
- `beyonders/` — Caminhos, sequências e ingredientes.
- `locais/` — Geopolítica e pontos de interesse (POIs).
- `historia/` — Linha do tempo central, eras e conflitos.
- `organizacoes/` — Sociedades secretas e agências oficiais.
- `lore/` — Conceitos gerais (moedas, rituais, idiomas).

## 🤖 Automações Assistidas (`.agents/`)

A interação da IA com o cofre é regida por regras rígidas em [AGENTS.md](.agents/AGENTS.md) (formatação sem poluição visual, anti-spoilers e links seguros) e executada pelas seguintes habilidades:

1.  **lotm-tracker:** Executa o resumo e mapeamento incremental de lore a partir de links de capítulos.
    - _Comando:_ `"gere o resumo para o próximo capítulo"`
2.  **lotm-promoter:** Promove notas simples de personagens (tag `#personagem`) para o formato Map of Content (tag `#personagem/moc`), segmentando o histórico em subnotas atômicas.
3.  **lotm-archiver:** Arquiva subnotas ativas de personagens MOC, movendo os arquivos físicos para `archived/` e gerando um sumário condensado na nota MOC principal.
