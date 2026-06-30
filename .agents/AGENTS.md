# General Guidelines para LLMs

Este documento define como qualquer Inteligência Artificial deve interagir com este cofre de notas no **Obsidian** (Segundo Cérebro).

> [!info] Skill Especializada
> Este cofre possui uma skill especializada (`lotm-tracker`) com instruções detalhadas de workflow operacional, taxonomia de tags e templates. Consulte `.agents/skills/lotm-tracker/SKILL.md` para o protocolo completo de processamento de capítulos e gerenciamento de notas. As regras deste documento (AGENTS.md) são gerais e complementares àquela skill.

## 1. Filosofia de Conteúdo

- **Notas Atômicas:** As notas devem ser curtas, diretas e focadas em pontos importantes. Evite explicações exaustivas ou redundantes.
- **Lembretes de Alto Valor:** O objetivo é que as notas sirvam como um aglomerado de lembretes agrupados por assunto.
- **Simplicidade:** Priorize a legibilidade humana e a estrutura de pastas/tags sobre plugins complexos.
- **Síntese Narrativa Ultra-Condensada (Regra de Ouro):** Ao descrever a evolução de personagens ou o histórico de entidades, use exclusivamente frases curtas contendo fatos secos e relevantes (mudanças de estado, decisões cruciais, revelações). É terminantemente proibido registrar rotinas, microações cotidianas, trajetos ou minúcias narrativas. Limite o acréscimo a no máximo 1 ou 2 frases curtas por evento.

## 2. Estrutura e Formatação (Padrão Visual)

### 2.1 Frontmatter (YAML)

Toda nota deve obrigatoriamente possuir o campo `tags` no topo, com hierarquia de 1 a 3 níveis (ex: `tema` ou `area/subarea/tema`). As notas podem conter uma ou mais tags estruturadas em formato de lista YAML. **Evite redundância de tags hierárquicas:** declare apenas a tag mais profunda na hierarquia (a tag-folha); o Obsidian resolve as tags pai de forma automática (ex: use apenas `deus/ortodoxo` em vez de declarar `deus` e `deus/ortodoxo`).

> [!tip] Exemplo Esclarecedor
> A regra de "apenas a tag mais profunda" se aplica **exclusivamente a tags da mesma hierarquia** (ex: `pai/filho`). Tags de **eixos ou categorias diferentes** não são redundantes entre si e devem coexistir.
>
> **Certo** (tags de eixos diferentes, ambas necessárias):
>
> ```yaml
> tags:
>   - deus/ortodoxo
>   - regiao/continente-norte
> ```
>
> **Errado** (tags da mesma hierarquia, a mais genérica é redundante):
>
> ```yaml
> tags:
>   - deus # ← redundante: a tag-pai `deus` é resolvida automaticamente
>   - deus/ortodoxo
> ```
>
> **Certo** (tags de eixos diferentes, sem redundância):
>
> ```yaml
> tags:
>   - personagem/moc
>   - organizacao/secreta
>   - regiao/continente-norte
> ```
>
> Resumo: se as tags compartilham o mesmo prefixo hierárquico (`deus/...`, `local/...`), use só a mais profunda. Se os prefixos são diferentes (`deus/...` vs. `regiao/...`), ambas podem coexistir sem problema.

O campo `aliases` é **opcional**. Se presente e não vazio, deve conter termos alternativos relevantes como:

- Tradução técnica (ex: "Cadeias de Markov" -> `Markov Chain`)
- Abreviação (ex: "Hidden Markov Models" -> `HMMs`)

> [!IMPORTANT]
> **Uso de Aliases em Links:** O Obsidian exige que links internos direcionados a aliases mencionem sempre a nota inicial física seguido pelo alias (formato `[[Nome Real da Nota|Alias]]`, ex: `[[Alger Wilson|O Enforcado]]`). Utilizar apenas o termo do alias diretamente em links (ex: `[[O Enforcado]]`) não funcionará e gerará links para notas fantasmas inexistentes.

Estrutura padrão recomendada (suporta múltiplas tags):

```
---
tags:
  - area/subarea/tema
  - outra_tag
aliases:
  - Termo Alternativo     # Opcional
---
```

### 2.2 Espaçamento

- Exatamente uma linha em branco entre blocos de markdown (parágrafos, listas, tabelas, callouts, code blocks, imagens).
- Tabelas, callouts e code blocks devem obrigatoriamente possuir uma linha em branco antes e depois.

### 2.3 Estilo de Texto

- **Negrito:** Permitido apenas para (a) primeira menção de um termo técnico-chave na nota, (b) keywords RFC 2119 (MUST/SHOULD/MAY), ou (c) rótulos de campos estruturados em listas de metadados (ex: `- **Chave:** Valor`). É estritamente proibido o uso de negrito para dar ênfase a palavras comuns, adjetivos, verbos ou frases inteiras no corpo dos parágrafos normais, a fim de evitar poluição visual. Máximo de 3 instâncias por seção H2 (excluindo rótulos de listas).
- **Itálico:** Permitido para ênfase metalinguística ou observações da revisão. Máximo de 2 instâncias por nota.
- **Negrito+Itálico combinado:** Proibido (`***texto***` ou `**_texto_**`).
- Evite uso excessivo de destaque. A sobriedade visual é prioridade.

### 2.4 Tabelas

- Máximo de 5 colunas e 15 linhas de dados.
- Proibido: listas aninhadas, quebras de linha, ou código inline dentro de células.
- Proibido: merge de células (colspan/rowspan) — Markdown puro não suporta.
- Exatamente uma linha em branco antes e depois.

### 2.5 Callouts

- Use callouts para incluir conteúdo adicional sem quebrar o fluxo da nota.
- Tipos nativos permitidos: `note`, `info`, `tip`, `warning`, `danger`, `abstract`, `question`, `example`, `quote`, `success`, `failure`, `bug`.
- Título opcional após o tipo: `> [!info] Titulo do Callout`.
- Exatamente uma linha em branco antes e depois.
- O conteúdo do callout segue as regras de formatação da nota (Markdown, links, etc.).

### 2.6 Imagens

- Use `![[nome-do-arquivo.ext]]` para embeds.
- Imagens devem ser armazenadas em uma subpasta `images/` relativa ao diretório da nota.
- Exatamente uma linha em branco antes e depois do embed.
- Legenda opcional: adicionar uma linha em itálico abaixo da imagem.

### 2.7 Brevidade (Soft Limits)

- Seções H2 que ultrapassam ~300 palavras (ou ~30 linhas físicas) devem ser subdivididas ou extraídas para notas filhas.
- Notas inteiras que ultrapassam ~800 palavras (ou ~80 linhas físicas) violam a filosofia de notas atômicas.
- Os limites são referenciais, não absolutos — use julgamento: se der para explicar em menos palavras, prefira menos palavras.

### 2.8 Resolução de Links Internos (Obsidian)

O Obsidian resolve links no formato `[[Nome da Nota]]` **pelo nome da nota, independentemente da sua localização em pastas**. Regras:

- `[[Personagem]]` encontra a nota de nome `Personagem.md` **em qualquer pasta do vault**, inclusive dentro de subpastas como `archived/`.
- **Não é necessário** incluir caminhos de pasta: `[[pasta/Nota]]` é redundante quando o nome é único no vault.
- O prefixo de caminho só é necessário quando **duas notas com o mesmo nome** existem em pastas diferentes (ambiguidade). Neste caso, o Obsidian solicitará desambiguação.
- **Regra para MOCs:** use sempre `[[Sub-nota]]` sem caminho de pasta, com alias se desejar texto de exibição diferente: `[[Sub-nota|Texto Exibido]]`. Isso mantém os links funcionais mesmo se a subnota for movida entre pastas (ex: para `archived/`).

> [!important]
> Links com caminho explícito (`[[pasta/Nota]]`) **funcionam mas são frágeis**: se a nota for movida para outra pasta, o link quebra. Links sem caminho (`[[Nota]]`) são robustos a movimentações de pasta.

## 3. Protocolo de Interação (Obrigatório)

Toda alteração deve seguir este rito rígido:

1. **Pesquisa/Análise:** Entender o contexto atual e reportar a análise ao usuário.
2. **Execução:** Realizar as modificações diretamente nos arquivos.

## 4. Uso de Git e Segurança

- **Papel Humano (REGRA INEGOCIÁVEL):** O uso do Git é papel exclusivo do humano. É terminantemente proibido que a IA execute qualquer comando Git. A IA pode, no máximo, propor um comando para o usuário rodar, mas jamais deve executá-lo por conta própria. Toda manipulação de repositório, commits ou branches deve ser feita manualmente pelo usuário.
- **Segurança:** Nunca remova informações existentes sem propor primeiro e justificar o motivo.

## 5. Tom de Voz

- Profissional, técnico, direto e sem "conversas fiadas".
