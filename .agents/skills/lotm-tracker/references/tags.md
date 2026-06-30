# Taxonomia de Tags do Vault

Este documento consolida todas as tags do vault com suas respectivas descrições e
regras de uso. Use como referência ao classificar entidades em notas novas ou
existentes.

> [!tip] Hierarquia Automática
> Declare apenas a tag mais profunda na hierarquia (ex: use `deus/ortodoxo` em vez
> de `deus` + `deus/ortodoxo`). O Obsidian resolve as tags pai automaticamente.

---

## Mapeamento Tag → Descrição

| Tag | Descrição | Exclusiva? |
|-----|-----------|------------|
| `#artefato` | Itens mágicos e artefatos selados | |
| `#caminho` | Caminhos Beyonder conhecidos | |
| `#caminho/sequencia` | Sequências e degraus específicos de caminhos Beyonder | |
| `#deus` | Divindades e deuses | |
| `#deus/antigo` | Divindades de eras passadas ou extintas | |
| `#deus/herege` | Divindades proibidas ou cultos não-ortodoxos | |
| `#deus/ortodoxo` | Divindades do panteão oficial reconhecido | |
| `#diario` | Registros e anotações do diário de Roselle | |
| `#historia/conflito` | Guerras, batalhas e crises comerciais/geopolíticas | |
| `#historia/era` | Eras históricas da novel | |
| `#historia/linha-tempo` | Marcação para a nota mestra de cronologia | **Sim** — apenas `historia/linha_do_tempo.md` |
| `#historia/marco` | Invenções, tratados, leis e descobertas importantes | |
| `#ingrediente` | Ingredientes Beyonder e materiais místicos | |
| `#local/bairro` | Subdivisões e distritos urbanos | |
| `#local/cidade` | Cidades e municípios (ex: Tingen, Backlund) | |
| `#local/continente` | Massas de terra globais | |
| `#local/estabelecimento/comercial` | Lojas, empresas e escritórios | |
| `#local/estabelecimento/ensino` | Faculdades, escolas primárias e técnicas | |
| `#local/estabelecimento/industrial` | Oficinas, fábricas e instalações de manufatura ou vapor | |
| `#local/estabelecimento/religioso` | Catedrais, templos e igrejas | |
| `#local/estabelecimento/residencial` | Casas, apartamentos e moradias | |
| `#local/pais` | Nações governadas (ex: Reino Loen) | |
| `#lore` | Conceitos gerais (moedas, costumes, religiões, idiomas) | |
| `#lore/moeda` | Moedas e sistemas monetários | |
| `#meta/moc` | Tags para notas estruturais e mapas de conteúdo (ex: MOC Geopolítico) | |
| `#meta/progresso` | Marcação para a nota de controle de progresso de leitura | **Sim** — apenas `progresso.md` |
| `#misterio` | Anotações sobre mistérios ativos e pistas | |
| `#organizacao/oficial` | Organizações governamentais, agências de segurança e igrejas ortodoxas estatais | |
| `#organizacao/secreta` | Cabalas ocultas, seitas Beyonder e ordens clandestinas | |
| `#personagem` | Personagens da obra (nota única com narrativa própria) | |
| `#personagem/[nome]` | Subnotas de personagem MOC (ex: `#personagem/klein`) | |
| `#personagem/moc` | Nota de personagem que funciona como MOC (Map of Content) | |
| `#regiao/continente-norte` | Região geopolítica do norte | |
| `#regiao/continente-sul` | Região geopolítica do sul | |

---

## Regras de Uso

### Hierarquia de Tags

Não declare tags-pai quando a tag-filha já está presente:

- ✅ Correto: `tags: [deus/ortodoxo, regiao/continente-norte]`
- ❌ Errado: `tags: [deus, deus/ortodoxo, regiao, regiao/continente-norte]`

Tags de eixos **diferentes** não são redundantes entre si e devem coexistir.

### Tags Exclusivas

As seguintes tags são de uso exclusivo de notas específicas e não devem ser
aplicadas a outras entidades:

| Tag | Nota Exclusiva |
|-----|----------------|
| `#historia/linha-tempo` | `historia/linha_do_tempo.md` |
| `#meta/progresso` | `progresso.md` |

### Flexibilidade

A taxonomia acima é um **guia**, não uma camisa-de-força. Tags não listadas
podem ser criadas conforme necessidade (ex: `#tecnologia`, `#local/mar`). As
únicas restrições são:

1. A tag não pode ser **semanticamente errada** para a entidade (ex: marcar um
   palácio residencial como `#local/estabelecimento/comercial`).
2. Tags que caracterizam fortemente a entidade (ex: `#personagem`, `#artefato`,
   `#deus/ortodoxo`) não podem ser omitidas.
3. Novas tags devem ser documentadas aqui futuramente se ganharem uso recorrente.
