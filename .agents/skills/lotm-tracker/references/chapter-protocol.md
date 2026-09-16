# Protocolo de Processamento de Capítulo (FASE 1)

> Este arquivo é carregado **apenas pelo subprocessador** da FASE 1. O loop principal não precisa lê-lo — ele só executa a FASE 2 (`SKILL.md`, seção 0).
> As regras de conteúdo (tags, formatação, estrutura de notas, spoilers) vivem no `SKILL.md`; este documento cobre o **fluxo operacional**.

O ciclo divide-se em duas fases:

- **FASE 1 — Processamento:** executada pelo subprocessador, isolada do contexto principal.
- **FASE 2 — Apresentação:** o loop principal apenas exibe o resumo retornado.

---

## 1. Carregar referências (o mínimo necessário)

1. Leia `references/tags.md` — taxonomia, hierarquias e tags exclusivas.
2. Leia `references/granularity-rules.md` — mapeamento entidade → pasta/tag.

**Não leia `references/templates/` inteiro.** São 20 arquivos e o capítulo toca poucos tipos. Gere o esqueleto do tipo que for criar, no momento de criar:

```bash
.agents/skills/lotm-tracker/scripts/new-note.sh <tipo> "<Nome>"
```

O script escreve o frontmatter e as seções do template, roteia para a pasta correta e nunca sobrescreve arquivo existente. Só abra um template manualmente se precisar consultar a intenção de um campo específico.

## 2. Identificar o próximo capítulo

Leia exclusivamente `progresso.md` na raiz do vault. O próximo capítulo é `[último capítulo] + 1`. Se o arquivo não existir ou estiver em branco, comece pelo Capítulo 1.

## 3. Obter o conteúdo da web

- URL primária: `https://centralnovel.com/lord-of-mysteries-capitulo-[numero]/`
- **Fallback:** se retornar 404 ou falhar, tente a URL secundária sem a barra final: `https://centralnovel.com/lord-of-mysteries-capitulo-[numero]`

## 4. Limpeza e análise mental

Retenha apenas o texto narrativo do capítulo, descartando botões, menus, links, comentários e propagandas. Faça uma leitura atenta e levante uma lista restrita dos nomes próprios, entidades (personagens, locais, organizações, deuses, artefatos) e conceitos citados.

## 5. Critério de mudança de estado narrativo

Aplique o filtro sobre cada entidade identificada:

- **Mudança de estado (ler e atualizar):** personagem agiu/tomou decisão/recebeu revelação; local foi palco de evento ou teve descrição expandida; artefato foi usado ou exibiu novo poder; organização ganhou membro ou regra; conceito de lore ou mecânica mística explicado em detalhes (mitos históricos, regras de poções, riscos de perda de controle).
- **Apenas citada (ignorar, sem merge):** menção passiva sem informação nova ("foi até a cidade", "lembrou do artefato", "passou pela igreja").

Entidades apenas citadas **não** devem ser lidas nem atualizadas.

## 6. Mapeamento de entidades e lazy-read

> [!IMPORTANT]
> Listar diretórios para inventariar o vault viola o princípio de *lazy loading*. Verifique existência abrindo o caminho esperado ou por busca direcionada ao nome exato — nunca varrendo pastas.

Para resolver "esta nota existe?" sem falso positivo (um `grep` pelo nome casa também com *menções* dentro de outras notas), use:

```bash
.agents/skills/lotm-tracker/scripts/find-note.sh "Nome ou Alias"
```

- Saída com caminho → a nota existe: **leia o conteúdo completo** e faça o merge.
- Saída `NAO ENCONTRADA` (exit 1) → classifique como NOVA.
- A ferramenta também denuncia quando o termo é um **alias**: nesse caso o link correto é `[[Nome Real|Alias]]`.

Classifique cada entidade como NOVA ou EXISTENTE combinando a leitura do capítulo com essa verificação.

### Regras de granularidade transversais

- **MOC Geopolítico:** toda localidade adicionada à geopolítica deve ser vinculada em `locais/moc-geopolitica.md`, respeitando a hierarquia Continente > País > Cidade > Bairro > Rua.
- **Bairros e ruas:** crie nota dedicada **apenas** se hospedarem POIs ou eventos cruciais; caso contrário, documente textualmente na nota da cidade-mãe. **Atenção a nomes ambíguos:** se o mesmo topônimo existe em duas cidades (ex: `Burgo Norte` em Tingen e em Backlund), prefira documentar textualmente — uma nota única tornaria o link ambíguo.
- **Linha do tempo:** eventos criados em `historia/eventos/` e eras em `historia/eras/` também devem ser registrados em `historia/linha_do_tempo.md`.
- **Entidades implícitas:** ao criar entidades de nome composto (ex: `Universidade de Backlund`), crie também a nota da entidade-pai implícita (`Backlund`).
- O mapeamento completo tipo → pasta → tag está em `references/granularity-rules.md`.

### Personagens MOC durante o lazy-read

- Tag `#personagem/moc` → é MOC:
  - leia a nota MOC (seção `## Fases da Narrativa` e, se houver, `## Eventos Arquivados`);
  - **ignore completamente** subnotas dentro de `archived/` — não verifique, não leia, não atualize;
  - subnotas ativas (fora de `archived/`) seguem o lazy-read normal.
- Tag `#personagem` → nota única, lazy-read normal.

## 7. Merge mental

Para cada entidade EXISTENTE lida:

1. Incorpore as informações novas respeitando a **Perspectiva Interna** (personagens) e as regras de estilo do `SKILL.md`.
2. Personagens de **nota única** (`#personagem`): se `## Evolução narrativa` acumular 5+ parágrafos, estruture obrigatoriamente em subseções H3 por fases lógicas.
3. Subnota ativa de **personagem MOC** (`#personagem/[nome]`): se `## Evolução narrativa` acumular 5+ parágrafos, **não** use H3. Aplique a **Divisão de Subnota Ativa por Tamanho**: crie nova subnota ativa com nome de arco descritivo, adicione o link no MOC e deixe a subnota anterior intocada para arquivamento posterior via `lotm-archiver`.
4. Verifique se a nota omitiu seção estrutural recomendada pelo template (ex: `## Estrutura e Hierarquia` para organizações, `## Proprietários e Frequentadores` para pontos de interesse). Se houver dados aplicáveis, recrie e popule.

## 8. Mistérios e hipóteses

`misterios.md` participa do processamento, mas **nunca é lido por inteiro de forma indiscriminada**:

1. **Consulta direcionada (obrigatória):** para cada entidade com mudança de estado, faça busca textual pelo nome exato em `misterios.md` e leia apenas os trechos retornados.
2. **Exceção — capítulos sistêmicos:** leia integralmente apenas quando o capítulo tratar predominantemente de regras gerais do misticismo, eras ou eventos globais sem âncora em entidade única.
3. **Adicione** dúvidas, pistas e hipóteses (inclusive suspeitas do protagonista) como perguntas ou descrições atômicas.
4. **Verifique** se mistérios anteriores foram elucidados: se sim, integre a resposta na nota da entidade e remova o item de `misterios.md`.

## 9. Buffer temporário (checklist, sem conteúdo final)

Garanta que `<vault>/.agents/tmp/` existe. Crie `.agents/tmp/cap-XX-buffer.md` apenas como **lista de trabalho** — nunca com o conteúdo final das notas:

```markdown
# Buffer: Capítulo XX - [Nome do Capítulo]

## Criar
- [ ] `caminho/Pasta/Entidade.md` — <1 linha: o que a nota deve registrar>

## Merge
- [ ] `caminho/Pasta/Entidade.md` — <1 linha: o que muda>

## Entradas especiais
- [ ] `misterios.md` — <novos mistérios e resolvidos>
- [ ] `diario_de_roselle.md` — <novas páginas, se aplicável>
- [ ] `locais/moc-geopolitica.md` — <novas localidades, se aplicável>
- [ ] `resumos/XXXX - [Título].md` — <resumo de 2-3 parágrafos>
```

O conteúdo final é escrito **uma única vez**, direto no destino, na etapa de batch write. Duplicá-lo aqui dobra o custo de saída sem benefício: o contexto do subprocessador é descartado ao final do ciclo.

## 10. Batch Write

Escreva todas as alterações em um único batch:

1. Notas novas (geradas via `scripts/new-note.sh`).
2. Notas atualizadas com o merge completo.
3. `progresso.md` → `Capítulo XX - Nome do Capítulo`.
4. `misterios.md`, conforme o buffer.
5. `diario_de_roselle.md`, se houver páginas novas.
6. `locais/moc-geopolitica.md`, se houver localidades novas.
7. `resumos/XXXX - [título].md` (4 dígitos), com o sumário de 2-3 parágrafos e links `[[Nota]]`/`[[Nota|Alias]]` para todas as entidades e conceitos do capítulo.

## 11. Deletar o buffer (obrigatório)

Após o batch write bem-sucedido, apague `.agents/tmp/cap-XX-buffer.md` imediatamente.

## 12. Validar a gravação

```bash
.agents/skills/lotm-tracker/scripts/validate.sh --fix-tmp
```

Verificação determinística de links fantasmas, links via alias direto, marcadores de capítulo, H1 divergente, comentários HTML residuais, lacunas de resumo e buffers órfãos. **Corrija tudo até a seção de fantasmas e de aliases sair `ok`** — não confie em releitura mental, o script é a fonte de verdade.

## 13. Retornar o resumo compacto

Devolva ao loop principal:

- número e nome do capítulo processado;
- lista de entidades criadas;
- lista de entidades alteradas (merge);
- sumário narrativo de 2-3 parágrafos, obrigatoriamente com os links Obsidian das entidades e conceitos.

---

## Checklists de pré-gravação (consolidados)

Antes de consolidar o batch write:

- [ ] **Origem única:** cada afirmação veio do capítulo processado ou de nota existente no vault — nunca de conhecimento interno da IA.
- [ ] **Sem pontes não-textuais:** não ligue pontos entre capítulos separados por mais de 1 capítulo sem link explícito no texto.
- [ ] **Sem classificações prematuras:** tags de organização, caminho ou divindade só entram se o texto afirmou explicitamente a afiliação.
- [ ] **Nomeação conservadora:** use o nome exato do texto; não traduza sem tradução oficial apresentada.
- [ ] **Links fantasmas:** todo `[[Nota]]` criado aponta para arquivo existente ou criado no mesmo ciclo.
- [ ] **Formato de alias:** `[[Nome Real|Alias]]`, nunca `[[Alias]]`.
- [ ] **H1 em aliases:** se o H1 difere do nome do arquivo, ele está em `aliases`.
- [ ] **Retenção de lore:** mecânicas místicas explicadas viraram nota em `lore/`; eras citadas viraram nota em `historia/eras/` + `linha_do_tempo.md`; conceitos não ficaram presos apenas na evolução narrativa de quem os explicou.
- [ ] **Sem comentários HTML** `<!-- -->` residuais nas notas gravadas.

---

## FASE 2 — Apresentação (loop principal)

O loop principal exibe apenas o resumo retornado pelo subprocessador e aguarda o próximo comando. Nenhum detalhe de tool calls internas (fetches, reads, writes) é exposto ao usuário.
