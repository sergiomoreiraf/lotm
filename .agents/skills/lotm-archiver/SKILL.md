---
name: lotm-archiver
description: Skill especialista em arquivar em lote subnotes de um personagem MOC, movendo todas as subnotas ativas para archived/ (exceto a última), gerando resumos condensados e atualizando a MOC ativa e a MOC arquivada correspondente.
---

# lotm-archiver: Arquivamento em Lote de Subnotas de Personagem MOC

Esta skill automatiza o arquivamento das subnotas ativas de um personagem em formato MOC. Ao receber o caminho da nota principal (MOC Principal) do personagem, ela move todas as subnotas listadas na seção `## Fases da Narrativa` para a subpasta `archived/`, exceto a última. Para cada subnota arquivada, gera um resumo condensado de 1 a 3 frases e atualiza a MOC Principal e a MOC Arquivada do personagem.

> **Acionamento:** Exclusivamente manual. O usuário fornece o caminho da nota principal do personagem em formato MOC (ex: `personagens/Alger Wilson.md`).

## Fail Fast (Validação de Pré-condições)

Antes de iniciar o fluxo, a skill DEVE validar rigidamente:

1. **A nota MOC indicada existe?** Se o arquivo da nota MOC principal não existir, interromper e reportar: _"Arquivo MOC não encontrado no caminho informado."_
2. **A nota é realmente um MOC de personagem?** Verificar se o arquivo possui a tag `#personagem/moc` no frontmatter. Se não possuir, interromper e reportar: _"O arquivo informado não é uma nota de personagem no formato MOC (tag #personagem/moc)."_
3. **Há fases suficientes para arquivar?** Contar o número de subnotas linkadas sob a seção `## Fases da Narrativa`. Se houver apenas uma ou nenhuma subnota ativa listada, não há o que arquivar (pois a última deve sempre permanecer ativa). Interromper e reportar: _"O personagem possui apenas uma ou nenhuma fase ativa listada. Nenhuma ação de arquivamento foi realizada."_

Se qualquer validação falhar, a skill não prossegue e reporta o erro ao usuário.

## Fluxo de Execução

### 1. Ler a Nota MOC Principal

Ler o conteúdo completo da nota MOC indicada (ex: `personagens/Alger Wilson.md`). Identificar os links das subnotas listadas sob a seção `## Fases da Narrativa`.

### 2. Determinar as Notas a Arquivar e a Nota Ativa

A partir da lista de links em `## Fases da Narrativa` (na ordem de sua aparição original):
- A **última** subnota da lista **deve permanecer ativa** no MOC Principal.
- **Todas as outras subnotas** anteriores na lista devem ser arquivadas.

### 3. Ler e Processar cada Subnota a Arquivar

Para cada subnota a ser arquivada (em ordem):
1. Ler o conteúdo completo da subnota ativa (em seu caminho atual na pasta do personagem).
2. Extrair a sua seção `## Evolução narrativa` e gerar um resumo condensado de 1 a 3 frases. O resumo deve:
   - Descrever os eventos-chave de forma concisa.
   - Seguir a regra de ouro de **síntese ultra-condensada**: focar apenas em mudanças de estado, revelações e eventos estruturantes importantes.
   - Seguir a proibição de marcadores de capítulo: **não** usar "No Capítulo X", "Caps Y" ou qualquer referência numérica direta de capítulos.

### 4. Mover as Subnotas Arquivadas

1. Garantir que a subpasta `archived/` exista dentro do diretório do personagem (ex: `personagens/[nome-da-pasta]/archived/`).
2. Mover fisicamente os arquivos das subnotas arquivadas da pasta ativa para a pasta `archived/`.
3. **Não alterar o nome do arquivo.** O Obsidian continuará resolvendo `[[Subnota]]` pelo nome do arquivo.

### 5. Criar ou Atualizar a MOC Arquivada

1. Verificar se a MOC Arquivada existe em `personagens/[nome-da-pasta]/archived/[Nome] (Arquivado).md`.
2. Se não existir, criá-lo com o frontmatter contendo a tag `#personagem/moc/arquivado` e o título principal `# [Nome] (Arquivado)`.
3. Adicionar/inserir na seção `## Eventos Arquivados` da MOC Arquivada as entradas das subnotas recém-arquivadas, respeitando a ordem cronológica em que estavam listadas:
   ```markdown
   - **[[[Título da Subnota]]]:** <!-- Resumo condensado gerado -->
   ```

### 6. Atualizar a MOC Principal

1. Sob a seção `## Fases da Narrativa`, manter **apenas** a linha da última subnota (a que permaneceu ativa). Remover as linhas correspondentes às subnotas arquivadas.
2. Garantir que o link para a MOC Arquivada esteja presente no final do arquivo:
   ```markdown
   ## Eventos Arquivados

   - [[[Nome do Personagem] (Arquivado)|Ver Eventos Arquivados]]
   ```

## Checklist de Verificação de Qualidade

Após executar a migração/arquivamento, o agente DEVE verificar mentalmente:

- [ ] **MOC Principal atualizada:** A seção `## Fases da Narrativa` mantém apenas a última subnota ativa.
- [ ] **Subnotas movidas:** Todos os arquivos de subnotas arquivadas foram movidos fisicamente para `archived/`.
- [ ] **MOC Arquivada atualizada:** A MOC Arquivada possui todas as notas arquivadas listadas em ordem em `## Eventos Arquivados` com seus resumos condensados e a tag `#personagem/moc/arquivado`.
- [ ] **Link para MOC Arquivada:** A MOC Principal no final contém o link `[[[Nome] (Arquivado)|Ver Eventos Arquivados]]`.
- [ ] **Nomes preservados:** Os nomes dos arquivos das subnotas não foram alterados ao serem movidos.
- [ ] **Sem marcadores de capítulo:** Nenhum resumo gerado contém "Capítulo X:" ou termos similares.
- [ ] **Links externos intactos:** Nenhum link `[[Subnota]]` em outras notas foi quebrado.
