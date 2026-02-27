import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../generator/puzzle_generator.dart';
import '../models/day_record.dart';
import '../models/sudoku_puzzle.dart';
import 'calendar_provider.dart';
import 'repository_provider.dart';

// ── Estado do Jogo ────────────────────────────────────────────────────────────

class GameState {
  final SudokuPuzzle puzzle;
  final List<List<int>> userBoard; // 0 = vazio, 1-9 = entrada do usuario
  final int? selectedRow;
  final int? selectedCol;
  final Set<(int, int)> conflicts;
  final List<(int, int, int)> undoStack; // (row, col, valorAnterior)
  final Duration elapsed;
  final bool timerRunning;
  final bool isComplete;
  final bool isLoading;
  final int hintsUsed;

  static const int maxHints = 3;

  const GameState({
    required this.puzzle,
    required this.userBoard,
    this.selectedRow,
    this.selectedCol,
    this.conflicts = const {},
    this.undoStack = const [],
    this.elapsed = Duration.zero,
    this.timerRunning = false,
    this.isComplete = false,
    this.isLoading = false,
    this.hintsUsed = 0,
  });

  bool get canUseHint => hintsUsed < maxHints && !isComplete;

  bool get hasSelection => selectedRow != null && selectedCol != null;

  int get selectedValue =>
      hasSelection ? _effectiveValue(selectedRow!, selectedCol!) : 0;

  int _effectiveValue(int row, int col) {
    final clue = puzzle.clueAt(row, col);
    return clue != 0 ? clue : userBoard[row][col];
  }

  bool isCellSelected(int row, int col) =>
      selectedRow == row && selectedCol == col;

  bool isCellHighlighted(int row, int col) {
    if (!hasSelection) return false;
    if (isCellSelected(row, col)) return false;
    return row == selectedRow ||
        col == selectedCol ||
        (row ~/ 3 == selectedRow! ~/ 3 && col ~/ 3 == selectedCol! ~/ 3);
  }

  bool hasSameNumber(int row, int col) {
    if (!hasSelection || selectedValue == 0) return false;
    final val = _effectiveValue(row, col);
    return val == selectedValue && !isCellSelected(row, col);
  }

  // ── copyWith com suporte a nullable via sentinela ─────────────────────────

  GameState copyWith({
    SudokuPuzzle? puzzle,
    List<List<int>>? userBoard,
    Object? selectedRow = const _Unset(),
    Object? selectedCol = const _Unset(),
    Set<(int, int)>? conflicts,
    List<(int, int, int)>? undoStack,
    Duration? elapsed,
    bool? timerRunning,
    bool? isComplete,
    bool? isLoading,
    int? hintsUsed,
  }) {
    return GameState(
      puzzle: puzzle ?? this.puzzle,
      userBoard: userBoard ?? this.userBoard,
      selectedRow: selectedRow is _Unset ? this.selectedRow : selectedRow as int?,
      selectedCol: selectedCol is _Unset ? this.selectedCol : selectedCol as int?,
      conflicts: conflicts ?? this.conflicts,
      undoStack: undoStack ?? this.undoStack,
      elapsed: elapsed ?? this.elapsed,
      timerRunning: timerRunning ?? this.timerRunning,
      isComplete: isComplete ?? this.isComplete,
      isLoading: isLoading ?? this.isLoading,
      hintsUsed: hintsUsed ?? this.hintsUsed,
    );
  }
}

class _Unset {
  const _Unset();
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class GameNotifier extends Notifier<GameState> {
  Timer? _timer;
  bool _disposed = false;

  @override
  GameState build() {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _timer?.cancel();
    });

    final date = ref.watch(selectedDateProvider);
    final seed = date.millisecondsSinceEpoch;
    final (puzzle, solution) = PuzzleGenerator.generate(seed);

    final initial = GameState(
      puzzle: SudokuPuzzle(clues: puzzle, solution: solution),
      userBoard: List.generate(9, (_) => List.filled(9, 0)),
      isLoading: true,
    );

    // Carrega estado salvo de forma assincrona
    Future.microtask(() => _loadSavedState(date));

    return initial;
  }

  Future<void> _loadSavedState(DateTime date) async {
    try {
      final repo = await ref.read(repositoryProvider.future);
      if (_disposed) return;

      final record = repo.getRecord(date);
      if (_disposed) return;

      if (record != null && record.status != DayStatus.notStarted) {
        final newBoard = record.boardState;
        final conflicts = _computeConflicts(newBoard, state.puzzle.clues);
        final complete = _checkComplete(newBoard, state.puzzle.clues, conflicts);

        state = state.copyWith(
          userBoard: newBoard,
          conflicts: conflicts,
          elapsed: record.elapsed,
          isComplete: complete,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (_) {
      if (!_disposed) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  // ── Selecao de celula ─────────────────────────────────────────────────────

  void selectCell(int row, int col) {
    if (state.isCellSelected(row, col)) {
      state = state.copyWith(selectedRow: null, selectedCol: null);
    } else {
      state = state.copyWith(selectedRow: row, selectedCol: col);
    }
  }

  // ── Input numerico ────────────────────────────────────────────────────────

  void inputNumber(int number) {
    if (!state.hasSelection) return;
    final row = state.selectedRow!;
    final col = state.selectedCol!;

    if (state.puzzle.isClue(row, col)) return;

    _startTimerIfNeeded();

    final previous = state.userBoard[row][col];
    final newBoard = _copyBoard(state.userBoard);
    newBoard[row][col] = number;

    final newConflicts = _computeConflicts(newBoard, state.puzzle.clues);
    final newUndo = [...state.undoStack, (row, col, previous)];
    final complete = _checkComplete(newBoard, state.puzzle.clues, newConflicts);

    state = state.copyWith(
      userBoard: newBoard,
      conflicts: newConflicts,
      undoStack: newUndo,
      isComplete: complete,
      timerRunning: complete ? false : state.timerRunning,
    );

    if (complete) _timer?.cancel();
    _saveAsync();
  }

  // ── Limpar celula selecionada ─────────────────────────────────────────────

  void clearCell() {
    if (!state.hasSelection) return;
    final row = state.selectedRow!;
    final col = state.selectedCol!;
    if (state.puzzle.isClue(row, col)) return;
    inputNumber(0);
  }

  // ── Desfazer ─────────────────────────────────────────────────────────────

  void undo() {
    if (state.undoStack.isEmpty) return;

    final newUndo = [...state.undoStack];
    final (row, col, prev) = newUndo.removeLast();

    final newBoard = _copyBoard(state.userBoard);
    newBoard[row][col] = prev;

    final newConflicts = _computeConflicts(newBoard, state.puzzle.clues);

    state = state.copyWith(
      userBoard: newBoard,
      conflicts: newConflicts,
      undoStack: newUndo,
      selectedRow: row,
      selectedCol: col,
      isComplete: false,
    );

    _saveAsync();
  }

  // ── Dica ───────────────────────────────────────────────────────────────

  void useHint() {
    if (!state.canUseHint) return;

    _startTimerIfNeeded();

    // Encontra celulas vazias ou erradas que podem receber dica
    final candidates = <(int, int)>[];
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (state.puzzle.isClue(r, c)) continue;
        final userVal = state.userBoard[r][c];
        final solutionVal = state.puzzle.solutionAt(r, c);
        if (userVal != solutionVal) {
          candidates.add((r, c));
        }
      }
    }

    if (candidates.isEmpty) return;

    // Se ha celula selecionada e ela e candidata, prioriza ela
    (int, int) target;
    if (state.hasSelection &&
        candidates.contains((state.selectedRow!, state.selectedCol!))) {
      target = (state.selectedRow!, state.selectedCol!);
    } else {
      // Escolhe aleatoriamente entre as candidatas
      candidates.shuffle();
      target = candidates.first;
    }

    final (row, col) = target;
    final correctValue = state.puzzle.solutionAt(row, col);
    final previous = state.userBoard[row][col];

    final newBoard = _copyBoard(state.userBoard);
    newBoard[row][col] = correctValue;

    final newConflicts = _computeConflicts(newBoard, state.puzzle.clues);
    final newUndo = [...state.undoStack, (row, col, previous)];
    final complete = _checkComplete(newBoard, state.puzzle.clues, newConflicts);

    state = state.copyWith(
      userBoard: newBoard,
      conflicts: newConflicts,
      undoStack: newUndo,
      hintsUsed: state.hintsUsed + 1,
      selectedRow: row,
      selectedCol: col,
      isComplete: complete,
      timerRunning: complete ? false : state.timerRunning,
    );

    if (complete) _timer?.cancel();
    _saveAsync();
  }

  // ── Persistencia ────────────────────────────────────────────────────────

  Future<void> _saveAsync() async {
    final date = ref.read(selectedDateProvider);
    final record = DayRecord(
      date: date,
      status: state.isComplete ? DayStatus.completed : _deriveStatus(),
      boardState: state.userBoard,
      elapsed: state.elapsed,
    );

    try {
      final repo = await ref.read(repositoryProvider.future);
      if (!_disposed) {
        await repo.saveRecord(record);
      }
    } catch (_) {
      // Falha silenciosa — o jogo continua funcionando sem persistencia
    }
  }

  DayStatus _deriveStatus() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (state.userBoard[r][c] != 0) return DayStatus.inProgress;
      }
    }
    return DayStatus.notStarted;
  }

  // ── Timer ─────────────────────────────────────────────────────────────────

  void _startTimerIfNeeded() {
    if (state.timerRunning || state.isComplete) return;
    state = state.copyWith(timerRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.timerRunning) {
        state = state.copyWith(elapsed: state.elapsed + const Duration(seconds: 1));
      }
    });
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static List<List<int>> _copyBoard(List<List<int>> board) =>
      List.generate(9, (r) => List<int>.from(board[r]));

  static Set<(int, int)> _computeConflicts(
    List<List<int>> userBoard,
    List<List<int>> clues,
  ) {
    List<int> effective(int r) => List.generate(
          9,
          (c) => clues[r][c] != 0 ? clues[r][c] : userBoard[r][c],
        );

    final conflicts = <(int, int)>{};

    for (int r = 0; r < 9; r++) {
      final row = effective(r);
      for (int c = 0; c < 9; c++) {
        final val = row[c];
        if (val == 0) continue;
        if (clues[r][c] != 0) continue;

        bool conflict = false;

        for (int cc = 0; cc < 9; cc++) {
          if (cc != c && effective(r)[cc] == val) {
            conflict = true;
            break;
          }
        }

        if (!conflict) {
          for (int rr = 0; rr < 9; rr++) {
            if (rr != r && effective(rr)[c] == val) {
              conflict = true;
              break;
            }
          }
        }

        if (!conflict) {
          final br = (r ~/ 3) * 3;
          final bc = (c ~/ 3) * 3;
          outer:
          for (int rr = br; rr < br + 3; rr++) {
            for (int cc = bc; cc < bc + 3; cc++) {
              if ((rr != r || cc != c) && effective(rr)[cc] == val) {
                conflict = true;
                break outer;
              }
            }
          }
        }

        if (conflict) conflicts.add((r, c));
      }
    }

    return conflicts;
  }

  static bool _checkComplete(
    List<List<int>> userBoard,
    List<List<int>> clues,
    Set<(int, int)> conflicts,
  ) {
    if (conflicts.isNotEmpty) return false;
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        final val = clues[r][c] != 0 ? clues[r][c] : userBoard[r][c];
        if (val == 0) return false;
      }
    }
    return true;
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final gameProvider = NotifierProvider<GameNotifier, GameState>(GameNotifier.new);
