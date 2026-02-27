import 'dart:math';

class PuzzleGenerator {
  /// Gera um puzzle com solução única a partir de um seed.
  /// O seed deve ser derivado da data: DateTime(ano, mes, dia).millisecondsSinceEpoch
  static (List<List<int>> puzzle, List<List<int>> solution) generate(int seed) {
    final random = Random(seed);
    final solution = _generateSolved(random);
    final puzzle = _removeNumbers(
      List.generate(9, (r) => List<int>.from(solution[r])),
      random,
    );
    return (puzzle, solution);
  }

  // ── Geração da grade resolvida ─────────────────────────────────────────────

  static List<List<int>> _generateSolved(Random random) {
    final grid = List.generate(9, (_) => List.filled(9, 0));
    _fillGrid(grid, random);
    return grid;
  }

  static bool _fillGrid(List<List<int>> grid, Random random) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          final numbers = List.generate(9, (i) => i + 1)..shuffle(random);
          for (final num in numbers) {
            if (_isValid(grid, row, col, num)) {
              grid[row][col] = num;
              if (_fillGrid(grid, random)) return true;
              grid[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  // ── Remoção de números (garantindo solução única) ─────────────────────────

  static List<List<int>> _removeNumbers(
    List<List<int>> puzzle,
    Random random,
  ) {
    final positions = [
      for (int r = 0; r < 9; r++)
        for (int c = 0; c < 9; c++) (r, c)
    ]..shuffle(random);

    int removed = 0;
    const target = 46; // ~35 pistas restantes (dificuldade fácil)

    for (final (row, col) in positions) {
      if (removed >= target) break;

      final backup = puzzle[row][col];
      puzzle[row][col] = 0;

      if (_hasUniqueSolution(puzzle)) {
        removed++;
      } else {
        puzzle[row][col] = backup;
      }
    }

    return puzzle;
  }

  // ── Verificação de solução única ──────────────────────────────────────────

  static bool _hasUniqueSolution(List<List<int>> puzzle) {
    final grid = List.generate(9, (r) => List<int>.from(puzzle[r]));
    return _countSolutions(grid) == 1;
  }

  /// Conta soluções, parando em 2 (para garantir unicidade).
  static int _countSolutions(List<List<int>> grid) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          int count = 0;
          for (int num = 1; num <= 9; num++) {
            if (_isValid(grid, row, col, num)) {
              grid[row][col] = num;
              count += _countSolutions(grid);
              grid[row][col] = 0;
              if (count > 1) return count;
            }
          }
          return count;
        }
      }
    }
    return 1; // nenhuma célula vazia → solução encontrada
  }

  // ── Validação ──────────────────────────────────────────────────────────────

  static bool _isValid(List<List<int>> grid, int row, int col, int num) {
    // linha
    for (int c = 0; c < 9; c++) {
      if (grid[row][c] == num) return false;
    }
    // coluna
    for (int r = 0; r < 9; r++) {
      if (grid[r][col] == num) return false;
    }
    // bloco 3x3
    final br = (row ~/ 3) * 3;
    final bc = (col ~/ 3) * 3;
    for (int r = br; r < br + 3; r++) {
      for (int c = bc; c < bc + 3; c++) {
        if (grid[r][c] == num) return false;
      }
    }
    return true;
  }
}
