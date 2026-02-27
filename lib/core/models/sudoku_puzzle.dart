class SudokuPuzzle {
  final List<List<int>> clues;
  final List<List<int>> solution;

  const SudokuPuzzle({required this.clues, required this.solution});

  static SudokuPuzzle empty() => SudokuPuzzle(
        clues: List.generate(9, (_) => List.filled(9, 0)),
        solution: List.generate(9, (_) => List.filled(9, 0)),
      );

  int clueAt(int row, int col) => clues[row][col];
  int solutionAt(int row, int col) => solution[row][col];
  bool isClue(int row, int col) => clues[row][col] != 0;
}
