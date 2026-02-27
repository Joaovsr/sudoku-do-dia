# Project Specification: Sudoku do Dia

## 1. Contexto Geral

**Nome do Projeto:** Sudoku do Dia

**Tipo:** Aplicativo de Sudoku focado em lógica e UX minimalista.

**Stack Técnica:** Flutter (Dart) com Riverpod para gerenciamento de estado.

**Estética Visual:** Dark Mode ("Kuro"), estilo minimalista/tech, remetendo a terminais Linux e hardware.

---

## 2. Decisões Técnicas

| Decisão | Escolha | Justificativa |
|---|---|---|
| State management | **Riverpod** | Moderno, testável, sem boilerplate excessivo |
| Persistência | **Isar** | Queries eficientes para o histórico do calendário |
| Validação | **Alertar** | Número entra na célula mas fica vermelho se inválido |
| Dificuldade no MVP | **Única (fácil)** | Foco no daily challenge, sem complexidade extra |
| Notas de célula | **Fora do MVP** | Pode ser adicionado em versão futura |
| Timer | **Sim** | O usuário deve ver quanto tempo levou para concluir |

---

## 3. Visão do MVP (Roadmap de Desenvolvimento)

O projeto deve seguir a seguinte ordem de prioridade:

1. **UI do Tabuleiro:** Construção da grade 9x9 com diferenciação visual para blocos 3x3, teclado numérico customizado e estados visuais das células.

2. **Gerador de Puzzles:** Algoritmo de backtracking para gerar puzzles com solução única. O seed é derivado da data atual normalizada (`DateTime(ano, mes, dia)`) para garantir que todos os usuários recebam o mesmo puzzle no mesmo dia.

3. **Lógica do Jogo:** Validação em tempo real, controle de estado das células, timer e detecção de conclusão.

4. **Persistência:** Salvar o progresso do dia atual e o histórico de dias anteriores usando Isar.

5. **Sistema "Daily Challenge":** Integrar gerador + persistência para o fluxo completo do desafio diário.

6. **Calendário de Progresso:** Visualização histórica (estilo contribuições do GitHub) para status de jogos passados.

---

## 4. Arquitetura de Pastas

```
lib/
  features/
    board/          # Widget do tabuleiro e células
    calendar/       # Calendário de progresso
    numpad/         # Teclado numérico customizado
  core/
    generator/      # Algoritmo de geração (backtracking) e seed diário
    models/         # SudokuPuzzle, CellState, DayRecord
    providers/      # Estado global com Riverpod
    persistence/    # Abstração do Isar (repositórios)
  app/
    app.dart        # MaterialApp, tema, roteamento
    routes.dart     # Definição de rotas
```

---

## 5. Telas (Navegação)

- **Tela Principal (Board):** Tabuleiro do desafio do dia, timer, teclado numérico.
- **Tela de Calendário:** Histórico visual de todos os dias jogados.
- *(Futuro)* **Configurações:** Tema, preferências de validação.

---

## 6. Especificações da Interface (UI/UX)

**Grade:** Matriz 9x9 composta por 9 subgrades de 3x3.

**Bordas:** Bordas externas e dos blocos 3x3 devem ser mais espessas que as bordas das células individuais.

**Paleta de Cores:**

| Elemento | Cor |
|---|---|
| Fundo | Preto Profundo / Cinza Escuro |
| Números Estáticos (Pistas) | Branco |
| Números do Usuário (válidos) | Azul Neon ou Verde Terminal |
| Números do Usuário (inválidos) | Vermelho |
| Célula selecionada | Destaque sutil (borda ou fundo levemente iluminado) |
| Células com mesmo número | Brilho suave ao selecionar uma delas |

**Input:** Teclado numérico customizado dentro do app (evitar teclado do sistema). Deve incluir botão de apagar.

---

## 7. Lógica e Funcionalidades Core

**Validação em Tempo Real:** Ao inserir um número, verificar conflitos em linha, coluna e bloco 3x3. O número é aceito na célula mas destacado em vermelho se inválido. Não impede a entrada.

**Timer:** Contador de tempo visível na tela principal. Começa ao primeiro input do usuário. Para ao concluir o puzzle. O tempo final é salvo junto ao registro do dia.

**Undo (Desfazer):** O usuário pode desfazer a última ação. Histórico de ações mantido em memória durante a sessão.

**Detecção de Conclusão:** O puzzle é considerado concluído quando todas as células estiverem preenchidas corretamente (sem conflitos). Exibe feedback visual e salva o resultado.

**Sistema de Status (Calendário):**

| Status | Cor | Condição |
|---|---|---|
| Concluído | Verde | Puzzle finalizado sem erros |
| Em progresso | Amarelo | Iniciado mas não concluído |
| Não iniciado | Cinza / Transparente | Nenhum input registrado |

**Persistência:** Salvo localmente com Isar. Cada registro de dia contém: data, estado do tabuleiro, tempo decorrido e status de conclusão.

**Seed Diário:** O seed para o gerador é derivado de `DateTime(ano, mes, dia).millisecondsSinceEpoch`, garantindo o mesmo puzzle para todos os usuários no mesmo dia independente do fuso horário local.
