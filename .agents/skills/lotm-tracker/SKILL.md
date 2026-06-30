---
name: lotm-tracker
description: Skill especialista em ler capítulos de Lord of the Mysteries fornecidos via links, consolidando e mapeando incrementalmente personagens, locais, artefatos, o diário de Roselle e mistérios, sem gerar spoilers sob nenhuma circunstância.
---

# Lord of the Mysteries Tracker (lotm-tracker)

Esta skill gerencia e atualiza de forma estritamente segura e incremental a base de dados de lore da web novel _Lord of the Mysteries_.

> **Aviso de Filosofia:** Esta skill não é um projeto de wiki pública — é um **caderno de leitura pessoal**. O objetivo é auxiliar a navegação de uma leitura densa, não produzir conteúdo enciclopédico canon. Precisão secundária é aceitável; spoilers são inaceitáveis.

## 1. Regra Fundamental de Mitigação de Spoilers (Tabula Rasa)

A IA que operar sob esta skill deve agir com **memória externa zero** sobre a obra.

- **Ignorância Absoluta:** Finja desconhecer o enredo, o destino dos personagens, os caminhos e as regras do sistema de magia além do que está explicitamente documentado no arquivo de texto do capítulo atual e nas notas do vault.
- **Sem Suposições:** Não infira a existência de sequências (ex: número total de sequências, classes não citadas) ou alter-egos antes que o próprio texto do capítulo revele explicitamente a informação.
- **Filtro de Saída:** Antes de gravar qualquer nota, valide se toda afirmação provém estritamente do capítulo lido ou de notas antigas.

## 2. Taxonomia de Tags (Obrigatório)

Toda nota sob esta skill deve conter metadados frontmatter YAML contendo tags do vault. Consulte `references/tags.md` para a lista completa com descrições, regras de hierarquia e tags exclusivas.

> [!info] Exemplos Representativos
> As tags exibidas nos templates de `references/templates/` são **exemplos representativos**, não uma checklist obrigatória. Use o `references/tags.md` para decidir quais tags aplicar a cada entidade. A combinação exata de tags pode variar conforme o contexto revelado no capítulo.

## 3. Diretrizes de Formatação e Estilo

> [!info] Regras Gerais de Formatação
> Este vault também é regido pelas diretrizes gerais de formatação contidas em `.agents/AGENTS.md` (limites de negrito/itálico, espaçamento, tabelas, callouts, frontmatter YAML). As regras abaixo são específicas da skill e complementam aquele documento.

- **Nomes em Português:** Todas as entidades, caminhos e termos devem ser nomeados na tradução oficial em português usada no texto fornecido (ex: "Caminho do Vidente", "Centavo de Cobre").
- **Atomicidade e Brevidade:** Cada nota deve ser concisa e funcionar como um lembrete rápido, e não como um resumo completo. Use o número de parágrafos que o conteúdo exigir, sem exageros.
- **Links Internos Integrados:** Os links Obsidian são no formato `[[Nota]]` e devem ser diluídos e integrados diretamente no próprio corpo de texto sempre que citar outro conceito ou personagem do vault.
- **Criação Obrigatória de Notas:** Sempre que criar um link interno no formato `[[Nota]]` em qualquer arquivo, você é OBRIGADO a criar fisicamente o arquivo correspondente na pasta adequada no mesmo ciclo de processamento (seja imediatamente ou no batch write final, conforme Seção 6.1.9), garantindo a inexistência de links para notas que não existem (links fantasmas).
- **Resolução de Nomes Provisórios (Unificada):** Se o nome de um personagem ou atacante não for mencionado, crie a nota usando uma descrição marcante (ex: `[[Homem de Cartola e Olhos Cinzas]]`). Da mesma forma, se o nome de uma classe/poção for revelado sem seu nível de sequência, use apenas o nome da classe (ex: `[[Alquimista]]`). Quando revelado o nome real ou o nível de sequência, **renomeie o arquivo** para o nome definitivo. Como as modificações são feitas direto no disco, você deve ativamente pesquisar (ex: busca textual, grep) por referências ao nome antigo em todo o vault e atualizar todos os links para o novo formato `[[Nome Real|Nome Antigo]]`. Isso evita links fantasmas e preserva a cronologia e o contexto histórico da leitura sem spoilers imediatos. Adicione também o nome antigo ao campo `aliases` no frontmatter YAML do arquivo renomeado. Exceção: se a nota antiga tiver conteúdo substancial que justifique preservação histórica, use merge em vez de rename.
- **Mapeamento de Entidades Implícitas (Nomes Compostos):** Ao mapear um ponto de interesse, organização ou artefato cujo nome contenha uma entidade geográfica ou histórica (ex: _Universidade de Backlund_, _Navio Fantasma da Era Tudor_, _Caderno da Família Antigonus_), o agente deve obrigatoriamente criar/atualizar a nota da entidade-pai implícita (ex: criar a cidade de `Backlund` ao mapear a `Universidade de Backlund`, ou a era `Era Tudor`/família `Família Antigonus`), garantindo que a base de lore esteja conectada por links.
- **Convenções Cronológicas:**
  - Datas são registradas APENAS no corpo narrativo, nunca no frontmatter YAML.
  - Use o formato textual que aparece no capítulo (ex: "1349", "Era do Caos").
  - A nota mestra `historia/linha_do_tempo.md` centraliza a cronologia.
- **Proibição de Marcadores de Capítulos:** É terminantemente proibido utilizar marcadores e referências temporais diretas baseados em capítulos (como "No Capítulo X", "Durante o Capítulo Y", "Capítulo Z:") em **todas** as notas do cofre, incluindo lore, rituais, deuses e locais, e não apenas em personagens. A narrativa de eventos deve ser descrita de forma fluida, imersiva e puramente baseada na cronologia interna e geral.
- **Diferenciação entre Divindade e Igreja (Obrigatório):** Sempre distinga a divindade (ex: `[[Senhor das Tempestades]]`) de sua respectiva instituição religiosa (ex: `[[Igreja do Senhor das Tempestades]]`). A igreja é uma organização e deve possuir uma nota própria em `organizacoes/` (tag `#organizacao/oficial`), enquanto a divindade possui sua nota em `deuses/` (tag `#deus`). Ao citar a igreja no texto, use links como `[[Igreja do Senhor das Tempestades]]` em vez de `Igreja do [[Senhor das Tempestades]]`.
- **Dinâmicas e Regras Internas:** Ao mapear organizações que possuem dinâmicas internas (como reuniões periódicas, regras, taxas, rituais de convocação, horários e dias estabelecidos), crie obrigatoriamente uma seção `## Funcionamento e Regras` ou `## Dinâmicas e Operações` para documentar essas regras.

## 4. Estrutura de Notas

- **Flexibilidade de Seções (Inclusão e Omissão):** Os templates fornecidos a seguir servem como guias de consistência visual. O agente tem total liberdade para: (1) Adicionar seções extras necessárias para documentar detalhes únicos da entidade; (2) Omitir seções ou campos inteiros dos modelos se não houver informações ou contexto no capítulo para preenchê-los, evitando seções vazias ou marcadores de 'N/A' que geram poluição visual.
- **Aliases para Qualquer Entidade:** O campo `aliases` no frontmatter YAML é opcional mas permitido para qualquer tipo de entidade (personagens, artefatos, organizações, divindades, locais, etc.). Use-o para registrar codinomes, títulos alternativos, nomes em outros idiomas ou designações temporárias. Quando o nome definitivo de uma entidade for revelado (ex: renomeação de provisório para definitivo), mova o nome anterior para o campo `aliases`.

### A. Progresso (`progresso.md`)

Mantém o rastreamento de leitura da novel para controle técnico.

> Consulte o template em `references/templates/progresso.md`.

### B. Diário de Roselle (`diario_de_roselle.md`)

Registra cada passagem do diário traduzida por Klein cronologicamente.

> Consulte o template em `references/templates/diario-de-roselle.md`.

### C. Mistérios (`misterios.md`)

Funciona como uma lista dinâmica de mistérios ativos. Quando um mistério for revelado em capítulos futuros, remova-o desta nota e insira a informação na nota da respectiva entidade.

> Consulte o template em `references/templates/misterios.md`.

### D. Deuses (`deuses/[Nome].md`)

Notas atômicas representando divindades adoradas. Podem ser criadas inicialmente apenas com esqueleto conceitual básico e tags correspondentes.

> Consulte o template em `references/templates/deus.md`.

### E. Sistema Beyonder (`beyonders/`)

A organização das notas Beyonder é dividida entre os Caminhos principais e as Sequências descobertas.

#### 1. Diretriz de Sequências Provisórias

Se o nome de uma poção/classe for revelado sem o seu nível de sequência correspondente, crie a nota usando apenas o nome da classe (ex: `Alquimista.md`). Assim que o nível for revelado na história (ex: Sequência 7), o arquivo deve ser renomeado para `Seq 7 - Alquimista.md`, aproveitando a refatoração automática de links do Obsidian, e o nome simples deve ser movido para o campo `aliases` no frontmatter.

#### 2. Modelo de Nota de Caminho Principal

> Consulte o template em `references/templates/caminho.md`.

#### 3. Modelo de Nota de Sequência

> Consulte o template em `references/templates/sequencia.md`.

#### 4. Modelo de Nota de Ingrediente

> Consulte o template em `references/templates/ingrediente.md`.

### F. Linha do Tempo e Eventos Históricos (`historia/`)

A cronologia e os fatos históricos são mapeados através de uma Nota Mestra de controle e notas atômicas para eras e eventos/conflitos.

#### 1. Modelo da Nota Mestra

> Consulte o template em `references/templates/linha-do-tempo.md`.

#### 2. Modelo de Nota de Era

> Consulte o template em `references/templates/era.md`.

#### 3. Modelo de Nota de Evento/Conflito

> Consulte o template em `references/templates/evento.md`.

### G. Organizações (`organizacoes/`)

As organizações (secretas ou oficiais) que Klein e outros personagens interagem.

#### 1. Modelo de Nota de Organização

> Consulte o template em `references/templates/organizacao.md`.

### H. Locais Geopolíticos (`locais/geopolitica/`)

Esta pasta reúne notas sobre continentes, países, cidades e bairros. As tags hierárquicas (`#local/continente`, `#local/pais`, `#local/cidade`, `#local/bairro`) categorizam o nível geopolítico.

> Consulte o template em `references/templates/local-geopolitico.md`.

### I. Pontos de Interesse (`locais/pontos_interesse/`)

Estabelecimentos específicos com função definida — escolas, igrejas, fábricas, bibliotecas, comércios, residências marcantes.

> Consulte o template em `references/templates/ponto-de-interesse.md`.

### J. Conceitos Gerais (`lore/`)

Notas sobre moedas, idiomas, rituais, costumes, materiais — qualquer conceito transversal que não se encaixa nas categorias anteriores.

> Consulte o template em `references/templates/lore.md`.

### K. Personagens (`personagens/[Nome].md`)

Mantém a evolução narrativa dos personagens ao longo da leitura.

**Regra de Unificação Inicial:** Casos de reencarnação ou fusão imediata no início da obra (como Zhou Mingrui se tornando Klein Moretti no Capítulo 1) devem ser mantidos na mesma nota (`Klein Moretti.md`), com as identidades anteriores como `aliases` no frontmatter YAML. O parágrafo introdutório deve esclarecer essa transição. Identidades secretas ou alter-egos de Beyonder revelados tardiamente devem ser mantidos em notas separadas até que a revelação ocorra, para evitar spoilers.

**Controle de Evolução Narrativa:**

- **Perspectiva Interna:** Toda nota de personagem deve ser escrita estritamente sob a perspectiva do próprio personagem. A seção `## Evolução narrativa` deve conter apenas ações diretas realizadas por ele, informações reveladas sobre ele ou interações em que participou ativamente. Ações de terceiros feitas em segredo não devem constar na evolução do personagem passivo.
- **Síntese e Concisão Narrativa:** A seção `## Evolução narrativa` deve ser um resumo executivo extremamente condensado, contendo apenas fatos secos e relevantes (mudanças de estado, revelações importantes e decisões cruciais do personagem). É terminantemente proibido detalhar rotinas, microações cotidianas, descrições secundárias ou passos intermediários procedimentais (como horários exatos de acordar, preparação de refeições, listas de compras, caminhos a pé ou tempo de trajetos). O acréscimo narrativo deve limitar-se a no máximo 1 ou 2 frases curtas por capítulo/evento. A evolução deve ser contada de forma puramente factual, sem prefixos ou marcadores de capítulos (como \"Capítulo X:\").

  > [!NOTE] Exemplo de Condensação Narrativa
  > - **Evite detalhismo:** *"Acorda pontualmente às 6:00 para preparar o desjejum da família. Ela tem 15 anos e frequenta o departamento de Vapor e Maquinaria da [[Escola Técnica de Tingen]] desde julho do ano anterior, sonhando em se tornar uma mecânica. Demonstrando grande habilidade para reparos, conserta o [[Relógio de Bolso de Prata]] de seu pai e ensina Klein a dar corda corretamente. Prepara o desjejum simples e instrui firmemente o irmão a comprar pão fresco (oito libras), carne de carneiro e ervilhas para a vinda de Benson no domingo, antes de caminhar 50 minutos a pé para economizar a passagem de carruagem a caminho de suas aulas."*
  > - **Prefira o formato ultra-condensado:** *"Ela tem 15 anos. Frequenta o departamento de Vapor e Maquinaria da [[Escola Técnica de Tingen]]. Demonstra grande habilidade para reparos."*
- **Evolução Narrativa Extensa:** Se a seção `## Evolução narrativa` de um personagem acumular 3 ou mais parágrafos de texto (ou descrever eventos de 3 ou mais blocos de capítulos/fases distintas), ela deve ser obrigatoriamente estruturada em subseções H3 organizadas por fases lógicas. As subseções H3 são estágios intermediários antes de uma eventual promoção a MOC, e o conteúdo ainda reside na mesma nota.

- **Formato de Personagem MOC:** Como alternativa para personagens com volume narrativo muito alto, eles podem receber uma pasta dedicada em `personagens/[pasta]/`, onde a nota principal se torna um MOC (Map of Content) com links para subnotas atômicas (ex: `personagens/klein-moretti/`).

  **Regras para Personagens MOC:**
  - A nota principal (MOC) usa a tag `#personagem/moc` em vez de `#personagem`.
  - As subnotas na pasta ativa usam a tag `#personagem/[nome]` (ex: `#personagem/klein`).
  - Os links no MOC usam o formato `[[Sub-nota]]` (sem caminho de pasta, apenas o nome da nota), com mini-descrições de 1 linha após cada link.
  - Subnotas movidas para `archived/` dentro da pasta do personagem **devem ser ignoradas**.
  - A MOC pode conter uma seção `## Resumo de Eventos Arquivados` com resumos condensados de subnotas que foram movidas para `archived/`.

**Template para Personagem de nota única** (template padrão para um novo personagem):

> Consulte o template em `references/templates/personagem.md`.

**Template para Personagem MOC**:

> Consulte o template em `references/templates/personagem-moc.md`.

### L. Artefatos (`artefatos/[Nome].md`)

Mapeia objetos de importância mística ou itens mágicos selados. A seção de detalhes é flexível e deve conter apenas os subtítulos aplicáveis ao contexto da descoberta.

> Consulte o template em `references/templates/artefato.md`.

### M. MOC Geopolítico (`locais/moc-geopolitica.md`)

Organiza a hierarquia e as relações geopolíticas descobertas ao longo da leitura.

> Consulte o template em `references/templates/moc-geopolitico.md`.

## 5. Anti-Spoiler Guardrails

### 5.1 Tabula Rasa (Reforço)

A IA deve operar com **memória externa zero** sobre a obra. Finja desconhecer o enredo, o destino dos personagens, os caminhos e as regras do sistema de magia além do que está explicitamente documentado no vault e no capítulo atual.

### 5.2 Checklists de Pré-Salvamento e Estruturação

Antes de criar ou modificar qualquer nota, o agente DEVE verificar mentalmente:

- [ ] **Origem única:** Cada afirmação veio do capítulo processado OU de nota existente no vault — nunca de conhecimento interno da IA.
- [ ] **Sem pontes não-textuais:** Não ligue pontos entre capítulos separados por mais de 1 capítulo a menos que haja link explícito no texto.
- [ ] **Sem classificações prematuras:** Tags de organização, caminho ou divindade só são adicionadas se o texto afirmou explicitamente a afiliação.
- [ ] **Tag checking:** Nenhuma tag adicionada vai além do que o texto atual revela.
- [ ] **Nomeação conservadora:** Use o nome exato do texto. Não traduza se a tradução oficial não foi apresentada.
- [ ] **Evolução Narrativa H3:** Se a nota for de um personagem e sua seção `## Evolução narrativa` possuir 3 ou mais parágrafos de texto no total, ela foi obrigatoriamente reestruturada em subseções H3 organizadas por fases lógicas.

### 5.3 Recusa Consciente

Se o usuário perguntar algo que exija conhecimento além do vault, o agente DEVE se recusar a responder, dizendo:

> "Isso ainda não foi revelado nos capítulos processados ou está além do que posso afirmar com segurança."

### 5.4 Anonimização de Exemplos

Ao dar exemplos na skill, use fatos históricos reais (Revolução Francesa, invenção da prensa móvel, Tratado de Tordesilhas) — nunca crie exemplos fictícios que possam tangenciar a obra.

### 5.5 Obsidian Link Guardrails (Obrigatório)

Antes de salvar qualquer arquivo no cofre, o agente DEVE verificar de forma rigorosa:

- [ ] **Inexistência de Links Fantasmas:** Garantir que nenhum link interno em formato `[[Nota]]` aponte para um arquivo que não exista fisicamente no cofre (a menos que a nota correspondente seja criada no mesmo turno de execução).
- [ ] **Formatos de Aliases:** Garantir que todos os links internos que façam referência a termos ou aliases de outras notas usem estritamente o formato `[[Nome Real da Nota|Alias]]`. É terminantemente proibido o uso do formato `[[Alias]]` diretamente como link interno.

### 6. Protocolo de Resumo de Capítulos (Lazy Loaded)

Ao receber o comando "gere o resumo para o próximo capítulo", todo o ciclo de processamento deve ser **delegado a um subprocessador** (executor isolado do contexto principal, como um sub-agente ou processo secundário, dependendo da plataforma). O subprocessador executa as fases abaixo e retorna apenas um resumo compacto ao loop principal.

O fluxo divide-se em duas fases:

- **FASE 1 — Processamento** (executada pelo subprocessador, isolada do contexto principal)
- **FASE 2 — Apresentação** (loop principal apenas exibe o resumo)

---

#### 6.1 FASE 1 — Processamento (delegado a subprocessador)

O subprocessador recebe as instruções completas desta seção e acesso ao vault, executando rigorosamente as etapas abaixo.

##### 6.1.0 Carregar Referências e Templates

Antes de qualquer operação, carregue os arquivos de referência da skill:

1. **Taxonomia de tags:** Leia `references/tags.md` para conhecer as tags disponíveis, hierarquias e regras.
2. **Mapa de pastas:** Leia `references/granularity-rules.md` para o mapeamento entidade → pasta/tag.
3. **Templates:** Leia todos os arquivos em `references/templates/` para ter os modelos de formatação disponíveis mentalmente durante todo o ciclo.

Mantenha estas referências carregadas durante toda a FASE 1 para consulta rápida ao criar ou atualizar notas.

##### 6.1.1 Identificar o Próximo Capítulo

Ler exclusivamente o arquivo `progresso.md` na raiz do cofre para identificar o último capítulo processado. O próximo capítulo será `[último capítulo] + 1`. Se o arquivo não existir ou estiver em branco, inicia-se pelo Capítulo 1.

##### 6.1.2 Obter Conteúdo da Web

- Realizar a busca de conteúdo por HTTP na URL primária: `https://centralnovel.com/lord-of-mysteries-capitulo-[numero]/`.
- **Fallback de URL:** Se a requisição retornar erro 404 ou falhar, tente a URL secundária sem a barra final: `https://centralnovel.com/lord-of-mysteries-capitulo-[numero]`.

##### 6.1.3 Limpeza Automática e Análise Mental

O conteúdo retornado da web deve ser limpo de forma a reter apenas o texto narrativo do capítulo, descartando obrigatoriamente botões, menus, links, comentários e propagandas. O agente deve fazer uma leitura atenta e uma análise mental do capítulo para levantar uma lista restrita apenas dos nomes próprios, entidades (personagens, locais, organizações, deuses, artefatos) e conceitos citados na narrativa.

##### 6.1.4 Aplicar Critério de Mudança de Estado Narrativo

Antes de prosseguir, aplicar o filtro de **mudança de estado narrativo** sobre cada entidade identificada:

- **Mudança de estado (deve ser lida e atualizada):** Personagem agiu/tomou decisão/recebeu revelação; local foi palco de evento/teve descrição expandida; artefato foi usado/exibiu novo poder; organização ganhou novo membro/nova regra.
- **Apenas citada (ignorar, sem merge):** Menção passiva sem nova informação ("ele foi até a cidade", "ela lembrou do artefato", "passou pela igreja").

Entidades apenas citadas **não** devem ser lidas nem atualizadas.

##### 6.1.5 Mapeamento de Entidades e Lazy-Read (Leitura Sob Demanda)

> [!IMPORTANT]
> A listagem de diretórios (seja por comandos de sistema ou ferramentas de varredura integradas) para fins de inventariar o vault viola o princípio de *lazy loading*. A verificação de existência de uma nota deve ser baseada estritamente em tentativas de abertura ou leitura direta do caminho de arquivo esperado (onde a falha de leitura indica que a nota não existe) ou por meio de buscas textuais direcionadas ao termo ou nome exato da entidade.

Com base na lista filtrada de entidades com mudança de estado, o agente deve:

1. **Classificar cada entidade mentalmente** como NOVA (nunca vista antes) ou EXISTENTE (já presente no vault). A classificação usa o conhecimento adquirido na leitura do capítulo combinado com verificação direta no vault.

2. **Lazy-Read:** Para cada entidade classificada como EXISTENTE, verificar a existência do arquivo no vault fazendo buscas direcionadas (grep/consulta por nome, sem listar diretórios inteiros):
   - Se o arquivo existir, **ler o conteúdo completo** da nota.
   - Se o arquivo **não** existir (classificação mental incorreta), reclassificar como NOVA.

3. **Regras de granularidade para criação de notas:** Consulte `references/granularity-rules.md` para o mapeamento completo de tipo de entidade → pasta e tag. Regras transversais extraídas abaixo para referência rápida:
   - **Regra do MOC Geopolítico:** Qualquer localidade adicionada à geopolítica (inclusive bairros ou ruas qualificadas) deve ser obrigatoriamente vinculada no MOC Geopolítico (`locais/moc-geopolitica.md`), respeitando a árvore hierárquica (Continente > País > Cidade > Bairro > Rua).
   - **Limite de granularidade para Bairros e Ruas:** Apenas crie notas dedicadas se hospedarem POIs ou eventos cruciais; caso contrário, documente textualmente na nota da cidade-mãe.
   - **Registro em Linha do Tempo:** Eventos históricos criados em `historia/eventos/` devem também ser registrados em `historia/linha_do_tempo.md`.
   - **Entidades Implícitas:** Ao criar entidades com nomes compostos (ex: `Universidade de Backlund`), crie também a nota da entidade-pai implícita (`Backlund`).

4. **Regra de Personagem MOC:** Durante o lazy-read, ao processar uma nota de personagem:
   - Se a nota possuir a tag `#personagem/moc`, ela é tratada como MOC. O agente deve:
     - **Ler a nota MOC** — contém a seção `## Fases da Narrativa` com links para subnotas ativas e, se houver, a seção `## Resumo de Eventos Arquivados`.
     - **Ignorar completamente subnotas dentro de diretórios `archived/`** — não verificar existência, não ler, não atualizar. Elas são invisíveis para o tracker.
     - **Subnotas ativas** (fora de `archived/`) — aplicar lazy-read normal: se houver mudança de estado narrativo, ler e fazer merge.
   - Se a nota usar a tag `#personagem` (padrão), aplicar lazy-read normal sem restrições.

##### 6.1.6 Merge Mental

Para cada entidade lida no lazy-read (EXISTENTES), realizar o merge mental:

1. Incorporar as novas informações do capítulo à nota existente.
2. Respeitar a **Perspectiva Interna** (para personagens) e demais regras de formatação.
3. Para notas de personagens: contar o total de parágrafos acumulados na evolução narrativa. Se houver 3 ou mais parágrafos, estruture obrigatoriamente a seção com subseções H3 por fases lógicas.
4. Manter o conteúdo final do merge disponível mentalmente para o buffer.

##### 6.1.7 Mapeamento de Mistérios e Hipóteses

O arquivo `misterios.md` deve ser considerado no processamento. A cada capítulo:

1. **Adicionar** novas dúvidas, pistas intrigantes e quaisquer suspeitas ou hipóteses levantadas pelo protagonista (como analogias ou suspeitas de transmigração de outros personagens) na forma de perguntas ou descrições atômicas.
2. **Verificar** se mistérios anteriores foram elucidados. Se resolvidos, a resposta deve ser integrada na nota da respectiva entidade e o item removido de `misterios.md`.

##### 6.1.8 Criar Buffer Temporário

Garantir que o diretório `<vault>/.agents/tmp/` exista (criá-lo se necessário). Em seguida, criar o arquivo `<vault>/.agents/tmp/cap-XX-buffer.md` (onde XX é o número do capítulo) consolidando tudo o que foi descoberto nas etapas anteriores:

```markdown
# Buffer: Capítulo XX - [Nome do Capítulo]

## Entidades NOVAS (criar)

- [ ] `caminho/pasta/Entidade.md` — <!-- conteúdo final completo -->

## Entidades EXISTENTES (merge)

- [ ] `caminho/pasta/Entidade.md` — <!-- conteúdo final completo pós-merge -->

## Entradas Especiais

- [ ] `misterios.md` — <!-- alterações: novos mistérios e/ou remoção de resolvidos -->
- [ ] `diario_de_roselle.md` — <!-- novas páginas do diário, se aplicável -->
- [ ] `locais/moc-geopolitica.md` — <!-- atualizações na hierarquia, se aplicável -->
```

##### 6.1.9 Batch Write

Escrever **todas** as alterações em um único batch:

1. Notas novas (entidades da seção NOVAS do buffer, cada uma com seu conteúdo final).
2. Notas atualizadas (entidades da seção EXISTENTES, cada uma com o merge completo).
3. `progresso.md` — atualizar para: `Capítulo XX - Nome do Capítulo`.
4. `misterios.md` — aplicar alterações registradas no buffer.
5. `diario_de_roselle.md` — aplicar alterações registradas no buffer, se houver.
6. `locais/moc-geopolitica.md` — atualizar se novas localidades foram adicionadas.

##### 6.1.10 Manter Buffer como Recibo de Undo

**Não remover o buffer imediatamente.** O buffer `.agents/tmp/cap-XX-buffer.md` deve ser mantido como recibo de undo. Ele só será removido no início do processamento do **próximo capítulo** (quando o novo buffer `cap-YY-buffer.md` for criado), permitindo recuperação em caso de falha parcial do batch write.

##### 6.1.11 Retornar Resumo Compacto

O subprocessador retorna ao loop principal um resumo contendo:

- Número e nome do capítulo processado.
- Lista de entidades criadas.
- Lista de entidades alteradas (merge).
- Sumário narrativo de 2-3 parágrafos.

---

#### 6.2 FASE 2 — Apresentação (loop principal)

O loop principal apenas exibe o resumo retornado pelo subprocessador e aguarda o próximo comando. Nenhum detalhe de tool calls internas (fetches, reads, writes) é exposto ao usuário.

---
