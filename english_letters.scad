// Format: ["points", [["letter", count], ["letter", count], ...]]

// English Scrabble letter frequencies, original
englishOriginal = [
  ["", [["", 2]]],
  ["1", [["E", 12], ["A", 9], ["I", 9], ["O", 8], ["N", 6], ["R", 6], ["T", 6], ["L", 4], ["S", 4], ["U", 4]]],
  ["2", [["D", 4], ["G", 3]]],
  ["3", [["B", 2], ["C", 2], ["M", 2], ["P", 2]]],
  ["4", [["F", 2], ["H", 2], ["V", 2], ["W", 2], ["Y", 2]]],
  ["5", [["K", 1]]],
  ["8", [["J", 1], ["X", 1]]],
  ["10", [["Q", 1], ["Z", 1]]],
];

// Alternative English Scrabble letter frequencies suggestions
// From https://www.reddit.com/r/scrabble/comments/1hyojaa/english_scrabble_letter_distribution_improvement/

// 2 blank tiles (scoring 0 points)
// 1 point: E ×12, A ×9, I ×8, O ×7, N ×6, R ×6, T ×6, L ×4, S ×4
// 2 points: D ×4, U ×4
// 3 points: C ×3, G ×3, B ×2, M ×2, P ×2
// 4 points: F ×2, H ×2, W ×2, Y ×2
// 5 points: K ×2, V ×2
// 8 points: J ×1, X ×1, Z ×1
// 10 points: Q ×1
englishRedditAlt1 = [
  ["", [["", 2]]],
  ["1", [["E", 12], ["A", 9], ["I", 8], ["O", 7], ["N", 6], ["R", 6], ["T", 6], ["L", 4], ["S", 4]]],
  ["2", [["D", 4], ["U", 4]]],
  ["3", [["C", 3], ["G", 3], ["B", 2], ["M", 2], ["P", 2]]],
  ["4", [["F", 2], ["H", 2], ["W", 2], ["Y", 2]]],
  ["5", [["K", 2], ["V", 2]]],
  ["8", [["J", 1], ["X", 1]]],
  ["10", [["Q", 1]]],
];

// 2 blank tiles (scoring 0 points)
// 1 point: E ×11, A ×9, I ×8, O ×8, N ×6, R ×6, T ×6, L ×4, S ×4
// 2 points: D ×4, U ×4
// 3 points: C ×3, G ×3, B ×2, M ×2, P ×2
// 4 points: F ×2, H ×2, W ×2, Y ×2
// 5 points: K ×2, V ×2
// 8 points: J ×1, X ×1, Z ×1
// 10 points: Q ×1
englishRedditAlt2 = [
  ["", [["", 2]]],
  ["1", [["E", 11], ["A", 9], ["I", 8], ["O", 8], ["N", 6], ["R", 6], ["T", 6], ["L", 4], ["S", 4]]],
  ["2", [["D", 4], ["U", 4]]],
  ["3", [["C", 3], ["G", 3], ["B", 2], ["M", 2], ["P", 2]]],
  ["4", [["F", 2], ["H", 2], ["W", 2], ["Y", 2]]],
  ["5", [["K", 2], ["V", 2]]],
  ["8", [["J", 1], ["X", 1]]],
  ["10", [["Q", 1]]],
];

englishTest = [
  ["10", [["Q", 1]]],
  ["9", [["Z", 1]]],
  ["8", [["M", 1]]],
];
