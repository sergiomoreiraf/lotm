---
name: lotm-tracker
description: Skill especialista em ler capítulos de Lord of the Mysteries fornecidos via links, consolidando e mapeando incrementalmente personagens, locais, artefatos, o diário de Roselle e mistérios, sem gerar spoilers sob nenhuma circunstância.
---

# Lord of the Mysteries Tracker (lotm-tracker)

Esta skill gerencia e atualiza de forma estritamente segura e incremental a base de dados de lore da web novel _Lord of the Mysteries_.

> **Aviso de Filosofia:** Esta skill não é um projeto de wiki pública — é um **caderno de leitura pessoal**. O objetivo é auxiliar a navegação de uma leitura densa, não produzir conteúdo enciclopédico canon. Precisão secundária é aceitável; spoilers são inaceitáveis.

## 0. Roteador: como processar um capítulo

Ao receber "gere o resumo para o próximo capítulo":

1. **Delegue a um subprocessador** (sub-agente ou processo secundário isolado, conforme a plataforma). Instrua-o a ler e executar integralmente:
   `.agents/skills/lotm-tracker/references/chapter-protocol.md`
   Esse arquivo contém todo o fluxo da FASE 1: identificar o capítulo, obter o texto da web, filtrar entidades por mudança de estado, lazy-read, merge, mistérios, buffer, batch write, validação e o resumo de retorno.
2. **Não carregue o protocolo no loop principal** — ele não é necessário aqui e custa contexto.
3. Ao receber o retorno do subprocessador, **exiba apenas** o resumo: número e nome do capítulo, entidades criadas, entidades alteradas e o sumário de 2-3 parágrafos. Nenhum detalhe de tool calls internas (fetches, reads, writes) é exposto.

## 1. Tabula Rasa — regra fundamental (fonte única)

A IA que operar sob esta skill — **inclusive o subprocessador do capítulo** — deve agir com **memória externa zero** sobre a obra.

- **Ignorância Absoluta:** finja desconhecer o enredo, o destino dos personagens, os caminhos e as regras do sistema de magia além do que está explicitamente documentado no texto do capítulo atual e nas notas do vault.
- **Sem Suposições:** não infira a existência de sequências (número total, classes não citadas) nem alter-egos antes que o próprio texto revele.
- **Filtro de Saída:** antes de gravar qualquer nota, valide se toda afirmação provém estritamente do capítulo lido ou de notas antigas.

## 2. Tags, formato e links

**Tags:** consulte `references/tags.md` para a lista completa, regras de hierarquia e tags exclusivas. Declare apenas a tag mais profunda de cada hierarquia (`deus/ortodoxo`, não `deus` + `deus/ortodoxo`); tags de eixos diferentes coexistem.

> [!info] Exemplos Representativos
> As tags dos templates em `references/templates/` são **exemplos representativos**, não uma checklist. Decida as tags pelo `references/tags.md` conforme o contexto revelado no capítulo.

**Formatação geral:** o vault é regido por `.agents/AGENTS.md` (negrito/itálico, espaçamento, tabelas, callouts, frontmatter, resolução de links). Não repita essas regras aqui.

**Regras específicas da skill:**

- **Nomes em Português:** toda entidade, caminho e termo usa a tradução oficial em português presente no texto fornecido (ex: "Caminho do Vidente", "Centavo de Cobre").
- **Atomicidade e Brevidade:** cada nota é um lembrete rápido, não um resumo completo. Use o número de parágrafos que o conteúdo exigir, sem exageros.
- **Links Internos Integrados:** links Obsidian no formato `[[Nota]]`, diluídos no próprio corpo do texto sempre que citar outro conceito ou entidade.
- **Criação Obrigatória de Notas:** ao criar um link `[[Nota]]`, o arquivo correspondente deve existir fisicamente ao fim do mesmo ciclo (imediatamente ou no batch write). Links fantasmas são proibidos.
- **Aliases:** o campo `aliases` do frontmatter é opcional e permitido para qualquer tipo de entidade. Registre codinomes, títulos alternativos, nomes em outros idiomas e designações temporárias. Se o H1 da nota difere do nome do arquivo, o H1 **deve** estar em `aliases`. Em links, use sempre `[[Nome Real da Nota|Alias]]` — `[[Alias]]` isolado é proibido.
- **Resolução de Nomes Provisórios:** sem nome próprio, crie a nota com uma descrição marcante (ex: `[[Homem de Cartola e Olhos Cinzas]]`). Classe ou poção revelada sem nível de sequência usa apenas o nome da classe (ex: `[[Alquimista]]`). Revelado o nome real ou o nível, **renomeie o arquivo**, mova o nome antigo para `aliases`, pesquise referências ao nome antigo no vault e atualize os links para `[[Nome Real|Nome Antigo]]`. Exceção: se a nota antiga tiver conteúdo substancial, use merge em vez de rename.
- **Mapeamento de Entidades Implícitas:** ao mapear algo de nome composto (ex: _Universidade de Backlund_, _Caderno da Família Antigonus_), crie/atualize obrigatoriamente a nota da entidade-pai implícita (ex: `Backlund`, `Família Antigonus`).
- **Convenções Cronológicas:** datas vão APENAS no corpo narrativo, nunca no frontmatter. Use o formato textual do capítulo (ex: "1349", "Era do Caos"). A cronologia centraliza-se em `historia/linha_do_tempo.md`.
- **Proibição de Marcadores de Capítulos:** proibido "No Capítulo X", "Durante o Capítulo Y", "Capítulo Z:" em **todas** as notas do cofre — lore, rituais, deuses e locais inclusive. A narrativa é fluida e baseada apenas na cronologia interna.
- **Divindade ≠ Igreja:** distinga sempre a divindade (`[[Senhor das Tempestades]]`, em `deuses/`) da instituição (`[[Igreja do Senhor das Tempestades]]`, em `organizacoes/`, tag `organizacao/oficial`). Escreva `[[Igreja do Senhor das Tempestades]]`, nunca `Igreja do [[Senhor das Tempestades]]`.
- **Dinâmicas e Regras Internas:** organizações com dinâmicas próprias (reuniões periódicas, regras, taxas, rituais de convocação, horários) exigem seção `## Funcionamento e Regras` ou `## Dinâmicas e Operações`.
- **Flexibilidade de Seções:** os templates são guias de consistência visual. Adicione seções para detalhes únicos da entidade e omita seções sem informação — nunca deixe seção vazia ou marcador "N/A".

### Scripts da skill

Verificação e scaffolding determinísticos, para não gastar contexto em conferência manual:

| Script | Função |
|---|---|
| `scripts/find-note.sh "<nome\|alias>"` | Resolve o caminho físico de uma nota; exit 1 se não existir. Substitui grep/tentativa de leitura. |
| `scripts/new-note.sh <tipo> "<Nome>"` | Cria a nota já com frontmatter e esqueleto do template, na pasta correta. Nunca sobrescreve. |
| `scripts/validate.sh [--fix-tmp]` | Checa links fantasmas, alias direto, marcadores de capítulo, H1 divergente, comentários HTML, lacunas de resumo e buffers órfãos. |

`new-note.sh` aceita: `personagem`, `personagem-moc`, `personagem-moc-arquivado`, `artefato`, `organizacao`, `deus`, `local-geopolitico`, `ponto-de-interesse`, `lore`, `caminho`, `sequencia`, `ingrediente`, `era`, `evento`, `resumo`.

## 3. Onde cada nota vive

O mapeamento completo tipo → pasta → tag obrigatória está em `references/granularity-rules.md`. Resumo operacional:

| Tipo de entidade | Pasta | Template |
|---|---|---|
| Personagens (nota única) | `personagens/` | `personagem.md` |
| Personagens MOC e subnotas | `personagens/[pasta]/` | `personagem-moc.md` / `personagem-moc-arquivado.md` |
| Divindades | `deuses/` | `deus.md` |
| Organizações oficiais e secretas | `organizacoes/` | `organizacao.md` |
| Artefatos e itens selados | `artefatos/` | `artefato.md` |
| Caminhos Beyonder | `beyonders/caminhos/` | `caminho.md` |
| Sequências | `beyonders/sequencias/` | `sequencia.md` (`Seq X - Nome.md`) |
| Ingredientes de poções | `beyonders/ingredientes/` | `ingrediente.md` |
| Eras e períodos | `historia/eras/` | `era.md` |
| Eventos e conflitos | `historia/eventos/` | `evento.md` |
| Cronologia (nota mestra) | `historia/linha_do_tempo.md` | `linha-do-tempo.md` |
| Continentes, países, cidades, bairros | `locais/geopolitica/` | `local-geopolitico.md` |
| Pontos de interesse | `locais/pontos_interesse/` | `ponto-de-interesse.md` |
| MOC geopolítico (nota mestra) | `locais/moc-geopolitica.md` | `moc-geopolitico.md` |
| Conceitos gerais | `lore/` | `lore.md` |
| Diário de Roselle (nota mestra) | `diario_de_roselle.md` | `diario-de-roselle.md` |
| Mistérios em aberto (nota mestra) | `misterios.md` | `misterios.md` |
| Progresso de leitura (nota mestra) | `progresso.md` | `progresso.md` |
| Resumos de capítulo | `resumos/` | `resumo.md` |

## 4. Regras por tipo de entidade

### Beyonder: sequências provisórias

Nome de poção/classe revelado sem nível de sequência → crie a nota só com o nome da classe (ex: `Alquimista.md`). Revelado o nível, renomeie para `Seq 7 - Alquimista.md` e mova o nome simples para `aliases`.

### Personagens

- **Unificação Inicial:** reencarnação ou fusão imediata no início da obra permanece na mesma nota (ex: Zhou Mingrui → `Klein Moretti.md`), com as identidades anteriores em `aliases`, e o parágrafo introdutório esclarece a transição. Identidades secretas ou alter-egos revelados tardiamente ficam em notas separadas até a revelação, para evitar spoilers.
- **Perspectiva Interna:** a nota é escrita estritamente sob a perspectiva do personagem. `## Evolução narrativa` contém só ações diretas dele, informações reveladas sobre ele ou interações em que participou ativamente. Ações de terceiros feitas em segredo não entram na evolução do personagem passivo.
- **Síntese e Concisão:** `## Evolução narrativa` é um resumo executivo de fatos secos e relevantes — mudanças de estado, revelações importantes, decisões cruciais. Proibido detalhar rotinas, microações cotidianas, descrições secundárias e passos procedimentais (horários, refeições, listas de compras, trajetos, tempos de caminhada). No máximo 1 ou 2 frases curtas por capítulo/evento, sem prefixos ou marcadores de capítulo.

  > [!NOTE] Exemplo de Condensação Narrativa
  > - **Evite detalhismo:** _"Acorda pontualmente às 6:00 para preparar o desjejum da família. Ela tem 15 anos e frequenta o departamento de Vapor e Maquinaria da [[Escola Técnica de Tingen]] desde julho do ano anterior, sonhando em se tornar uma mecânica. Demonstrando grande habilidade para reparos, conserta o [[Relógio de Bolso de Prata]] de seu pai e ensina Klein a dar corda corretamente. Prepara o desjejum simples e instrui firmemente o irmão a comprar pão fresco (oito libras), carne de carneiro e ervilhas para a vinda de Benson no domingo, antes de caminhar 50 minutos a pé para economizar a passagem de carruagem a caminho de suas aulas."_
  > - **Prefira o formato ultra-condensado:** _"Ela tem 15 anos. Frequenta o departamento de Vapor e Maquinaria da [[Escola Técnica de Tingen]]. Demonstra grande habilidade para reparos."_

- **Evolução Extensa:** se `## Evolução narrativa` acumular 5 ou mais parágrafos (ou eventos de 5+ blocos de capítulos/fases), reestruture obrigatoriamente em subseções H3 por fases lógicas. As subseções são estágios intermediários antes de uma eventual promoção a MOC, e o conteúdo permanece na mesma nota.
- **Formato MOC:** personagens de volume narrativo muito alto podem receber pasta dedicada `personagens/[pasta]/`, com a nota principal virando MOC.
  - A nota principal fica em `personagens/[Nome].md` e usa `#personagem/moc`.
  - Subnotas ativas usam `#personagem/[nome]` (ex: `#personagem/klein`).
  - Links do MOC usam `[[Sub-nota]]` sem caminho de pasta, com mini-descrição de 1 linha.
  - Subnotas em `archived/` **devem ser ignoradas** pelo tracker.
  - A seção `## Eventos Arquivados` do MOC existe apenas se houver arquivadas, com o link `[[Nome (Arquivado)|Ver Eventos Arquivados]]`.
  - O MOC secundário fica em `personagens/[pasta]/archived/[Nome] (Arquivado).md`, usa `#personagem/moc/arquivado` e lista links com resumos de 1 a 3 frases.
  - **Divisão de Subnota Ativa por Tamanho:** atingidos 5+ parágrafos em `## Evolução narrativa`, a subnota ativa não é mais atualizada. Crie uma nova subnota ativa com nome de arco descritivo, adicione o link no MOC e deixe a anterior intocada na pasta ativa, para arquivamento manual posterior via `lotm-archiver`.

### Resumos de capítulo

Arquivo `resumos/[numero] - [título].md`, com 4 dígitos e zeros à esquerda (ex: `resumos/0008 - uma nova era.md`). O conteúdo é o sumário narrativo de 2-3 parágrafos retornado pelo subprocessador. **Obrigatório:** integrar links `[[Nota]]` ou `[[Nota|Alias]]` para todas as entidades e conceitos criados ou alterados no capítulo.

### Demais tipos

Deuses, organizações, locais, artefatos, lore, eras e eventos seguem exclusivamente o template correspondente (§3) e as regras transversais de `references/granularity-rules.md` — em especial o registro obrigatório no MOC geopolítico, na linha do tempo e a criação de entidades-pai implícitas.

## 5. Guardrails de saída

### Recusa Consciente

Se o usuário perguntar algo que exija conhecimento além do vault, recuse:

> "Isso ainda não foi revelado nos capítulos processados ou está além do que posso afirmar com segurança."

### Anonimização de Exemplos

Ao dar exemplos na skill, use fatos históricos reais (Revolução Francesa, invenção da prensa móvel, Tratado de Tordesilhas) — nunca exemplos fictícios que possam tangenciar a obra.

### Validação Determinística

Antes de encerrar o ciclo, rode `scripts/validate.sh`. Ele é a fonte de verdade sobre links fantasmas, formato de alias, marcadores de capítulo, H1 sem alias, comentários HTML residuais, lacunas de resumo e buffers órfãos. Checklist mental não substitui o script.
