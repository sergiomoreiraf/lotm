---
name: lotm-archiver
description: Skill especialista em arquivar manualmente uma subnota de personagem MOC, movendo-a para a subpasta archived/ e atualizando a MOC com um resumo condensado.
---

# lotm-archiver: Arquivo de Subnota de Personagem MOC

Esta skill move uma subnota ativa de um personagem em formato MOC para a subpasta `archived/`, gera um resumo condensado de 1 a 3 frases e atualiza a MOC do personagem.

> **Acionamento:** Exclusivamente manual. O usuário fornece o caminho completo da subnota a ser arquivada.

## Fail Fast (Validação de Pré-condições)

Antes de iniciar o fluxo, a skill DEVE validar rigidamente:

1. **A subnota de destino existe?** Se o arquivo indicado não existir, interromper e reportar: _"Arquivo não encontrado no caminho informado."_
2. **A subnota está dentro de uma pasta de personagem MOC?** Verificar se a nota MOC do personagem (dois níveis acima: `personagens/[pasta]/`) possui a tag `#personagem/moc`. Se não, interromper: _"A subnota não pertence a um personagem em formato MOC. Esta skill só opera em personagens com tag #personagem/moc."_
3. **A subnota já está em `archived/`?** Se o caminho já contiver `/archived/`, interromper: _"A subnota já está arquivada. Esta skill só arquiva subnotas ativas."_

Se qualquer validação falhar, a skill não prossegue e reporta o erro ao usuário.

## Fluxo de Execução

### 1. Ler a Subnota

Ler o conteúdo completo da subnota indicada, incluindo toda a `## Evolução narrativa`.

### 2. Ler as MOCs do Personagem

Ler a nota MOC Principal do personagem (ex: `personagens/Klein Moretti.md`) para identificar:

- A seção `## Fases da Narrativa` — para remover o link da subnota sendo arquivada.

Se o arquivo de MOC Arquivada já existir (ex: `personagens/[pasta]/archived/[Nome] (Arquivado).md`), ler seu conteúdo para identificar a seção `## Eventos Arquivados` e anexar o novo resumo. Caso contrário, ele deverá ser criado.

### 3. Gerar Resumo Condensado

Produzir um resumo de 1 a 3 frases que capture os eventos principais da subnota. O resumo deve:

- Descrever eventos-chave de forma concisa.
- Seguir a proibição de marcadores de capítulo: não usar "No Capítulo X", "Durante o Capítulo Y" ou qualquer referência temporal direta baseada em numeração de capítulos. Use fluência narrativa e cronologia interna.

### 4. Atualizar as MOCs

**Atualizar MOC Principal (MOC Ativa):**
- **Remover** da seção `## Fases da Narrativa` a linha que referencia a subnota sendo arquivada.
- **Garantir link para MOC Arquivada:** Se o MOC Principal não possuir a seção `## Eventos Arquivados` e o link correspondente, criá-la no final do arquivo:
  ```markdown
  ## Eventos Arquivados

  - [[[Nome do Personagem] (Arquivado)|Ver Eventos Arquivados]]
  ```

**Atualizar/Criar MOC Arquivada:**
- Se o arquivo do MOC Arquivado (ex: `personagens/[pasta]/archived/[Nome] (Arquivado).md`) não existir, criá-lo com a tag `#personagem/moc/arquivado` e o título `# [Nome] (Arquivado)`.
- **Adicionar** (ou inserir cronologicamente) na seção `## Eventos Arquivados` da MOC Arquivada o novo resumo:
  ```markdown
  ## Eventos Arquivados

  - **[[[Título da Subnota]]]:** <!-- Resumo de 1 a 3 frases dos eventos principais. -->
  ```

### 5. Mover a Subnota para archived/

1. Garantir que o diretório `personagens/[pasta]/archived/` exista (criá-lo se necessário).
2. Mover o arquivo da subnota para `personagens/[pasta]/archived/`.
3. **Não alterar o nome do arquivo.** O Obsidian continuará resolvendo `[[Subnota]]` pelo nome, independente da pasta.

### 6. Preservar Links Externos

Outras notas que referenciam a subnota via `[[Subnota]]` continuam funcionando, pois o Obsidian resolve pelo nome do arquivo, não pela localização na pasta.

## Checklist de Verificação de Qualidade

Após executar o arquivamento, o agente DEVE verificar mentalmente:

- [ ] **Subnota movida:** O arquivo foi movido para `archived/` e não existe mais na pasta ativa.
- [ ] **MOC Principal atualizada:** O link da subnota foi removido de `## Fases da Narrativa`.
- [ ] **Link para MOC Arquivada:** A seção `## Eventos Arquivados` com o link `[[[Nome] (Arquivado)|Ver Eventos Arquivados]]` existe na MOC Principal.
- [ ] **MOC Arquivada atualizada:** A entrada correspondente foi adicionada à seção `## Eventos Arquivados` do MOC Arquivado (criado se não existia) com a tag `#personagem/moc/arquivado`.
- [ ] **Sem marcadores de capítulo:** O resumo não contém "Capítulo X:", "Caps" ou qualquer referência a numeração de capítulos.
- [ ] **Pasta `archived/` existe:** O diretório foi criado se necessário.
- [ ] **Nome do arquivo preservado:** O nome da subnota não foi alterado ao ser movida.
- [ ] **Links externos intactos:** Nenhum link `[[Subnota]]` em outras notas foi quebrado.
