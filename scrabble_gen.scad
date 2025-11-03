//Custom variables. All measurements in mm

/* [Text] */
//Letter or number on the tile - used only in "oneTile" mode (see below) when index is set to -1
letter = "A";
//Secondary text/symbol - used only in "oneTile" mode (see below) when index is set to -1
secondaryText = "1";
font = "Montserrat:style=Bold";

/* [Tile size] */
//x axis
width = 19.0; //.01
//y axis
depth = 19.0; //.01
//z axis
height = 4.0;
//Should be between between 0 and 1/2 the shorted side
radius = 3.0;
//Radius detail
$fn = 200;

/* [Text placement] */
layerHeight = 0.12;
//Depth of letter relief (positive for engraved, negative for raised)
letterDepth = 3 * layerHeight; // 0.1
//Horizontal offset for main letter from the center of the tile
mainLetterXOffset = 0; //.01
//Vertical offset for main letter from bottom edge of the tile
mainLetterYOffset = 5.5; //.01
//Horizontal offset for secondary text from right edge of the tile
secondaryTextXOffset = -2; //.01
//Vertical offset for secondary text from bottom edge of the tile
secondaryTextYOffset = 2; //.01
//Size of the main letter (as a fraction of the tile size)
textScale = 0.45; // .01
//Size of secondary text (as a fraction of main text size)
secondaryTextScale = 0.3; // .01

/* [Hidden] */
//["letter", "points", number of a given tile in the game]
letterData = [
  ["1", [["A", 5], ["D", 3], ["E", 5], ["I", 4], ["K", 3], ["L", 3], ["N", 5], ["O", 6], ["P", 3], ["R", 3], ["S", 4], ["T", 4], ["V", 4]]],
  ["2", [["Á", 2], ["C", 3], ["H", 3], ["Í", 3], ["J", 2], ["M", 3], ["U", 3], ["Y", 2], ["Z", 2]]],
  ["3", [["B", 2], ["É", 2], ["Ě", 2]]],
  ["4", [["Č", 1], ["Ř", 2], ["Š", 2], ["Ů", 1], ["Ý", 2], ["Ž", 1]]],
  ["5", [["F", 1], ["G", 1], ["Ú", 1]]],
  ["6", [["Ň", 1]]],
  ["7", [["Ó", 1], ["Ť", 1]]],
  ["8", [["Ď", 1]]],
  ["10", [["X", 1]]],
  ["", [["", 2]]],
];

//Calculate text sizes
textSize = width > depth ? depth * textScale : width * textScale;
secondaryTextSize = textSize * secondaryTextScale;

// Modes:
/* [Modes] */
mode = 2; // [1:oneTile - set for export via script, 2:allTiles]
index = -1;
if (mode == 1) {
  oneTile();
} else if (mode == 2) {
  allTiles();
} else {
  oneTile();
}

//Make tile(s):
//----------------------------------------
module oneTile() {
  // For oneTile, we need to find the correct letter and its points
  selectedLetter = letter;
  selectedPoints = secondaryText;
  if (index >= 0) {
    // Find the group and the letter within the group
    group = letterData[index];
    selectedPoints = group[0];
    selectedLetter = group[1][0][0]; // Default: first letter in group
    // Optionally, you can select a specific letter in the group if needed
  }
  LetterTile(selectedLetter, selectedPoints);
}

module allTiles() {
  // Helper function to calculate cumulative index
  function countBefore(groupIdx) =
    groupIdx == 0 ? 0
    : len(letterData[groupIdx - 1][1]) + countBefore(groupIdx - 1);

  for (g = [0:len(letterData) - 1]) {
    points = letterData[g][0];
    pairs = letterData[g][1];
    baseIdx = countBefore(g);
    for (j = [0:len(pairs) - 1]) {
      idx = baseIdx + j;
      translate(
        [
          (idx % 10) * (width + 2),
          -floor(idx / 10) * (depth + 2),
          0,
        ]
      )
        LetterTile(pairs[j][0], str(points));
    }
  }
}

//-----------------------------------------

module Tile() {
  linear_extrude(height=height, center=true)
    offset(r=radius)
      square([width - 2 * radius, depth - 2 * radius], center=true);
}

module PlaceTile() {
  translate([0, 0, height / 2]) Tile();
}

module PlaceLetter(letter) {
  translate(
    [
      mainLetterXOffset,
      -depth / 2 + mainLetterYOffset,
      letterDepth < 0 ? height : height - letterDepth,
    ]
  ) {
    linear_extrude(height=abs(letterDepth), convexity=5)
      scale([1, 1, 1])
        text(
          letter,
          size=textSize,
          font=font,
          halign="center",
          valign="bottom"
        );
  }
}

module PlaceSecondaryText(secondaryText) {
  translate(
    [
      width / 2 + secondaryTextXOffset,
      -depth / 2 + secondaryTextYOffset,
      letterDepth < 0 ? height : height - letterDepth,
    ]
  ) {
    linear_extrude(height=abs(letterDepth), convexity=5)
      scale([1, 1, 1])
        text(
          secondaryText,
          size=secondaryTextSize,
          font=font,
          halign="right",
          valign="bottom"
        );
  }
}

module LetterTile(letter, secondText) {
  if (letterDepth < 0) {
    union() {
      color("white") PlaceTile();
      color("black") PlaceLetter(letter);
      color("black") PlaceSecondaryText(secondText);
    }
  } else {
    difference() {
      color("white") PlaceTile();
      color("black") PlaceLetter(letter);
      color("black") PlaceSecondaryText(secondText);
    }
  }
}
