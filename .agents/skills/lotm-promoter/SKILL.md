---
name: lotm-promoter
description: Skill especialista em transformar manualmente um personagem de nota única (tag #personagem) para formato MOC (tag #personagem/moc), criando pasta dedicada com subnotas atômicas e reestruturando a nota principal como MOC.
---

# lotm-promoter: Promoção de Personagem para Formato MOC

Esta skill converte um personagem que está em formato de **nota única** (narrativa inteira em uma nota com tag `#personagem`) para o **formato MOC** (tag `#personagem/moc`, pasta dedicada com subnotas atômicas).

> **Acionamento:** Exclusivamente manual. O usuário fornece o caminho da nota do personagem a ser promovido.

## Fail Fast (Validação de Pré-condições)

Antes de iniciar o fluxo, a skill DEVE validar rigidamente:

1. **A nota de destino existe?** Se o arquivo indicado não existir, interromper e reportar: _"Arquivo não encontrado no caminho informado."_
2. **A nota é um personagem tag `#personagem`?** Se a nota não possuir a tag `#personagem` no frontmatter (incluindo verificar se já é `#personagem/moc`), interromper e reportar: _"A nota informada não é um personagem em formato de nota única (tag #personagem). Esta skill só opera em personagens que ainda não foram promovidos a MOC."_
3. **A nota não é de outro tipo?** Se a tag for de artefato, local, organização ou qualquer outra classe, interromper com: _"A nota informada não é um personagem. Esta skill só aceita personagens (tag #personagem)."_

Se qualquer validação falhar, a skill não prossegue e reporta o erro ao usuário.

## Fluxo de Execução

### 1. Ler a Nota do Personagem

Ler o conteúdo completo da nota indicada pelo usuário, incluindo toda a seção `## Evolução narrativa` e eventuais subseções H3.

### 2. Analisar a Evolução Narrativa

Identificar as subseções H3 existentes (fases lógicas) na `## Evolução narrativa`. Se não houver H3, analisar o conteúdo narrativo e propor uma divisão por fases lógicas com base nos eventos do personagem. A divisão é sugestão da skill — o usuário pode ajustar posteriormente.

### 3. Criar a Pasta do Personagem

Criar o diretório `personagens/[nome-do-personagem]/` (normalizado sem espaços ou caracteres especiais, em minúsculas).

### 4. Criar Subnotas Atômicas

Para cada fase/subseção H3 identificada:

- Criar uma subnota com o conteúdo daquela fase em `personagens/[pasta]/`.
- O título da subnota deve ser descritivo do arco (ex: `Ingresso nos Falcões Noturnos.md`).
- Adicionar frontmatter YAML com tag `#personagem/[nome]` (ex: `#personagem/klein`).
- A descrição inicial deve ser concisa, contextualizando o arco.
- Manter a seção `## Evolução narrativa` com o conteúdo daquela fase.

### 5. Reescrever a Nota Principal como MOC

A nota principal (mesmo nome de arquivo) é reescrita como MOC:

- **Tag:** Alterar de `#personagem` para `#personagem/moc`.
- **Seção `## Fases da Narrativa`:** Listar cada subnota criada com link `[[Sub-nota]]` e mini-descrição de 1 frase.
- **Remover** a seção `## Evolução narrativa` original (o conteúdo foi migrado para as subnotas).
- **Preservar** a descrição introdutória do personagem.
- **Preservar** o campo `aliases` no frontmatter, se existente.

### 6. Preservar Links Externos

Links de outras notas para `[[Personagem]]` continuam funcionando pois o arquivo mantém o mesmo nome. **Não** tentar relink automático de notas externas para subnotas específicas.

### 7. Template do MOC

```markdown
---
tags:
  - personagem/moc
aliases:
  - [Aliases anteriores, se houver]
---

# [Nome do Personagem]

<!-- Descrição introdutória do personagem em 1 parágrafo (preservada da nota original). -->

## Fases da Narrativa

- [[Subnota 1]] — <!-- Mini-descrição de 1 frase do arco. -->
- [[Subnota 2]] — <!-- Mini-descrição de 1 frase do arco. -->
```

### 8. Template da Subnota

```markdown
---
tags:
  - personagem/[nome]
---

# [Título da Subnota]

<!-- Descrição concisa do arco em 1-2 parágrafos: contexto, eventos principais, relevância para o personagem. Use [[links]] para conectar a locais, organizações e outros personagens. -->

## Evolução narrativa

<!-- Parágrafos cronológicos e fluidos relatando a evolução do personagem neste arco: ações diretas, decisões cruciais, revelações. Sem marcadores de capítulo. -->
```

## Checklist de Verificação de Qualidade

Após executar a promoção, o agente DEVE verificar mentalmente:

- [ ] **MOC existe:** O arquivo principal (`[Personagem].md`) foi reescrito como MOC com tag `#personagem/moc`.
- [ ] **Links corretos:** Os links no MOC usam `[[Subnota]]` sem caminho de pasta.
- [ ] **Sem links fantasmas:** Cada `[[Subnota]]` no MOC aponta para um arquivo que foi criado fisicamente.
- [ ] **Narrativa migrada:** O conteúdo da `## Evolução narrativa` original foi distribuído entre as subnotas, sem perda de informação relevante.
- [ ] **Tags consistentes:** Subnotas usam `#personagem/[nome]` e não `#personagem` ou `#personagem/moc`.
- [ ] **Aliases preservados:** Aliases do frontmatter original foram mantidos no MOC.
- [ ] **Descrição introdutória preservada:** O parágrafo inicial do personagem não foi perdido.
- [ ] **Pasta personagem foi criada:** `personagens/[pasta]/` existe com as subnotas dentro.
- [ ] **Proibição de marcadores:** Nenhuma subnota contém "Capítulo X:" no texto narrativo.
