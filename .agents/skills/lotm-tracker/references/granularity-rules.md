# Mapa de Pastas do Vault

Este documento mapeia cada pasta do vault ao tipo de entidade que ela armazena,
incluindo tags obrigatórias e regras de criação. Use como referência ao decidir
onde criar ou rotear uma nota.

> [!tip] Uso Combinado com Templates
> Para o formato estrutural de cada tipo de nota, consulte os templates em
> `references/templates/` correspondentes.

---

## Mapeamento Entidade → Pasta

| Tipo de Entidade | Pasta | Tag Obrigatória | Notas |
|---|---|---|---|
| Eras, épocas, períodos históricos | `historia/eras/` | `#historia/era` | |
| Crises econômicas, guerras, conflitos geopolíticos | `historia/eventos/` | `#historia/conflito` ou `#historia/marco` | Deve também registrar o evento em `historia/linha_do_tempo.md` |
| Linha do tempo cronológica (nota mestra) | `historia/linha_do_tempo.md` | `#historia/linha-tempo` | Tag exclusiva — não usar em outras notas |
| Impérios, reinos, nações, cidades, mares | `locais/geopolitica/` | `#local/pais`, `#local/cidade` ou `#local/continente` | Deve vincular no MOC Geopolítico (`locais/moc-geopolitica.md`) respeitando a hierarquia Continente > País > Cidade > Bairro > Rua |
| Bairros ou ruas | `locais/geopolitica/` | `#local/bairro` | Criar nota dedicada **apenas se** houver POIs ou eventos cruciais; caso contrário, documentar textualmente na nota da cidade-mãe |
| Pontos de interesse (escolas, igrejas, fábricas, comércios, residências) | `locais/pontos_interesse/` | `#local/estabelecimento/*` (ensino, religioso, comercial, industrial, residencial) | |
| MOC Geopolítico (nota mestra) | `locais/moc-geopolitica.md` | `#meta/moc` | |
| Organizações governamentais, igrejas estatais | `organizacoes/` | `#organizacao/oficial` | |
| Cabalas ocultas, seitas, ordens clandestinas | `organizacoes/` | `#organizacao/secreta` | |
| Famílias nobres, reais, facções ou grupos | `organizacoes/` | `#organizacao/oficial` ou `#organizacao/secreta` | |
| Personagens (nota única) | `personagens/` | `#personagem` | |
| Personagens MOC (pasta dedicada) | `personagens/[pasta]/` | `#personagem/moc` (MOC) / `#personagem/[nome]` (subnotas) / `#personagem/moc/arquivado` (MOC arquivado) | MOC de arquivados fica em `personagens/[pasta]/archived/` |
| Divindades e deuses | `deuses/` | `#deus`, `#deus/ortodoxo`, `#deus/antigo` ou `#deus/herege` | |
| Artefatos, itens mágicos, objetos selados | `artefatos/` | `#artefato` | Criar mesmo se citados indiretamente ou de forma provisória |
| Caminhos Beyonder | `beyonders/caminhos/` | `#caminho` | |
| Sequências de caminhos Beyonder | `beyonders/sequencias/` | `#caminho/sequencia` | Nome do arquivo: `Seq X - Nome.md` |
| Ingredientes de poções | `beyonders/ingredientes/` | `#ingrediente` | |
| Conceitos gerais (moedas, idiomas, rituais, costumes) | `lore/` | `#lore` (+ `#lore/moeda` se aplicável) | |
| Diário de Roselle (nota mestra) | `diario_de_roselle.md` | `#diario` | |
| Mistérios em aberto (nota mestra) | `misterios.md` | `#misterio` | |
| Progresso de leitura (nota mestra) | `progresso.md` | `#meta/progresso` | Tag exclusiva — não usar em outras notas |

---

## Regras Transversais

### MOC Geopolítico (Obrigatório)

Qualquer localidade adicionada à geopolítica (inclusive bairros ou ruas
qualificadas) deve ser obrigatoriamente vinculada no MOC Geopolítico
(`locais/moc-geopolitica.md`), respeitando a árvore hierárquica:

    Continente > País > Cidade > Bairro > Rua

### Limite de Granularidade para Bairros e Ruas

Apenas crie notas dedicadas em `locais/geopolitica/` para bairros ou ruas que
hospedem pontos de interesse (POIs) ou eventos cruciais da narrativa. Caso
contrário, documente-os textualmente dentro da nota da respectiva cidade ou
bairro-mãe.

### Registro em Linha do Tempo

Eras e Épocas históricas criadas em `historia/eras/` e eventos históricos (crises, guerras, conflitos, marcos) criados em `historia/eventos/` devem também ser registrados em `historia/linha_do_tempo.md` de forma cronológica.

### Entidades Implícitas (Nomes Compostos)

Ao mapear uma entidade cujo nome contenha uma entidade geográfica ou histórica
(ex: `Universidade de Backlund`, `Navio Fantasma da Era Tudor`), crie
obrigatoriamente a nota da entidade-pai implícita (ex: criar `Backlund` em
`locais/geopolitica/` ao mapear a universidade). Isso garante que a base de
lore esteja conectada por links.
