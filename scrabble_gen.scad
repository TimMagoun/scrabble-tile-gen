//Custom variables. All measurements in mm

// Import letter data files
include <english_letters.scad>
include <czech_letters.scad>

/* [Text] */
//Letter or number on the tile - used only in "oneTile" mode (see below) when index is set to -1
letter = "A";
//Point value for the tile - used only in "oneTile" mode (see below) when index is set to -1
secondaryText = "1";
// font = "Montserrat:style=Bold";
font = "ArialRoundedMTBold";

// Choose letter dataset (picker/dropdown in the OpenSCAD Customizer)
// Extend the list with the actual variable names from your included files.
letterSet = "englishTest"; // ["englishOriginal", "englishRedditAlt1", "englishRedditAlt2", "englishTest"]

// Map the selected name to the actual letterData variable
letterData =
  letterSet == "englishTest" ? englishTest
  : letterSet == "englishOriginal" ? englishOriginal
  : letterSet == "englishRedditAlt1" ? englishRedditAlt1
  : letterSet == "englishRedditAlt2" ? englishRedditAlt2
  : englishTest;

/* [Tile size] */
//x axis
width = 19.0; //.01
//y axis
depth = 19.0; //.01
//z axis
height = 4.0;
//Should be between between 0 and 1/2 the shorted side
radius = 3.0;
//Bottom chamfer size (0 = no chamfer)
bottomChamfer = 3.0; //.01
//Radius detail
$fn = 200;

/* [Text placement] */
layerHeight = 0.12; // 0.04
//Depth of letter relief as multiple of layer height (positive for engraved, negative for raised)
letterLayers = 3; // 1
//Horizontal offset for main letter from the center of the tile
mainLetterXOffset = 0; //.01
//Vertical offset for main letter from bottom edge of the tile
mainLetterYOffset = 5.5; //.01
//Size of the main letter (as a fraction of the tile size)
textScale = 0.45; // .01

/* [Point Value Symbols] */
//Size of point value symbols (squares and circles) in mm
symbolSize = 1.5; //.01
//Spacing between point value symbols in mm
symbolSpacing = 0.5; //.01
//Distance from bottom edge of tile to center of symbols
symbolYOffset = 1.5; //.01

/* [Printer Settings] */
//Printer plate width in mm
plateWidth = 257; //.1
//Printer plate depth in mm
plateDepth = 257; //.1
//Gap between plates in mm
plateGap = 100; //.1

/* [Hidden] */
//["points", [["letter", count], ["letter", count], ...]]
// Select which letter set to use
letterDepth = layerHeight * letterLayers;

//Calculate text sizes
textSize = width > depth ? depth * textScale : width * textScale;

// Modes:
/* [Modes] */
mode = 2; // [1:oneTile - set for export via script, 2:allTiles]
index = -1;
//Which part to render for multi-color printing
renderPart = 0; // [0:both, 1:tiles only (white), 2:letters only (black)]
//Flip tiles 180 degrees (letters face down on print bed)
letterOnPlate = true;
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
  // Helper function to calculate cumulative tile count before a given group and pair
  function countBeforeGroup(groupIdx) =
    groupIdx == 0 ? 0
    : countInGroup(groupIdx - 1) + countBeforeGroup(groupIdx - 1);

  function countInGroup(groupIdx) =
    sumCounts(letterData[groupIdx][1], len(letterData[groupIdx][1]) - 1);

  function sumCounts(pairs, idx) =
    idx < 0 ? 0
    : pairs[idx][1] + sumCounts(pairs, idx - 1);

  function countBeforePair(groupIdx, pairIdx) =
    pairIdx == 0 ? 0
    : letterData[groupIdx][1][pairIdx - 1][1] + countBeforePair(groupIdx, pairIdx - 1);

  // Calculate tiles per plate
  tilesPerRow = floor(plateWidth / (width + 2));
  tilesPerCol = floor(plateDepth / (depth + 2));
  tilesPerPlate = tilesPerRow * tilesPerCol;

  for (g = [0:len(letterData) - 1]) {
    points = letterData[g][0];
    pairs = letterData[g][1];
    baseIdx = countBeforeGroup(g);

    for (j = [0:len(pairs) - 1]) {
      letter = pairs[j][0];
      count = pairs[j][1];
      pairBaseIdx = baseIdx + countBeforePair(g, j);

      // Render each tile 'count' times
      for (k = [0:count - 1]) {
        idx = pairBaseIdx + k;

        // Calculate which plate this tile belongs to
        plateNum = floor(idx / tilesPerPlate);
        tileInPlate = idx % tilesPerPlate;

        // Position within the current plate
        localX = (tileInPlate % tilesPerRow) * (width + 2);
        localY = -floor(tileInPlate / tilesPerRow) * (depth + 2);

        // Offset for the plate
        plateX = plateNum * (plateWidth + plateGap);

        translate([plateX + localX, localY, 0])
          LetterTile(letter, points);
      }
    }
  }
}

//-----------------------------------------

module Tile() {
  if (bottomChamfer > 0) {
    // Create tile with 45-degree bottom chamfer
    hull() {
      // Top profile (full size) - starts at chamfer height
      translate([0, 0, height / 2 - 0.01])
        linear_extrude(height=0.02, center=true)
          offset(r=radius)
            square([width - 2 * radius, depth - 2 * radius], center=true);

      // Profile at chamfer transition (reduced by chamfer amount)
      translate([0, 0, -height / 2 + bottomChamfer])
        linear_extrude(height=0.02, center=true)
          offset(r=radius)
            square([width - 2 * radius, depth - 2 * radius], center=true);

      // Bottom profile (reduced by chamfer for 45-degree angle)
      translate([0, 0, -height / 2 + 0.01])
        linear_extrude(height=0.02, center=true)
          offset(r=radius)
            square([width - 2 * radius - 2 * bottomChamfer, depth - 2 * radius - 2 * bottomChamfer], center=true);
    }
  } else {
    // Standard tile without chamfer
    linear_extrude(height=height, center=true)
      offset(r=radius)
        square([width - 2 * radius, depth - 2 * radius], center=true);
  }
}

module PlaceTile() {
  translate([0, 0, height / 2]) Tile();
}

module PlaceLetter(letter) {
  translate(
    [
      mainLetterXOffset,
      -depth / 2 + mainLetterYOffset,
      letterDepth < 0 ? height : height - letterDepth - 0.001,
    ]
  ) {
    linear_extrude(height=abs(letterDepth) + 0.002, convexity=5)
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
  // Calculate position based on corner
  // Corner 1: bottom-left, 2: bottom-right, 3: top-right, 4: top-left
  xPos =
    (secondaryTextCorner == 1 || secondaryTextCorner == 4) ? -width / 2 + secondaryTextInset // left side
    : width / 2 - secondaryTextInset; // right side

  yPos =
    (secondaryTextCorner == 1 || secondaryTextCorner == 2) ? -depth / 2 + secondaryTextInset // bottom
    : depth / 2 - secondaryTextInset; // top

  hAlign = (secondaryTextCorner == 1 || secondaryTextCorner == 4) ? "left" : "right";
  vAlign = (secondaryTextCorner == 1 || secondaryTextCorner == 2) ? "bottom" : "top";

  translate(
    [
      xPos,
      yPos,
      letterDepth < 0 ? height : height - letterDepth - 0.001,
    ]
  ) {
    linear_extrude(height=abs(letterDepth) + 0.002, convexity=5)
      scale([1, 1, 1])
        offset(r=secondaryTextBoldness)
          text(
            secondaryText,
            size=secondaryTextSize,
            font=font,
            halign=hAlign,
            valign=vAlign
          );
  }
}

module PlacePointSymbols(points) {
  // Calculate number of squares (5 points each) and circles (1 point each)
  numSquares = floor(points / 5);
  numCircles = points % 5;
  totalSymbols = numSquares + numCircles;

  // Calculate total width of symbol group
  // Total width = width of all symbols + spacing between them
  totalWidth = (totalSymbols * symbolSize) + ( (totalSymbols - 1) * symbolSpacing);

  // Starting X position (leftmost symbol, centered around origin)
  startX = -totalWidth / 2;

  // Y position from bottom of tile
  yPos = -depth / 2 + symbolYOffset;

  // Z position
  zPos = letterDepth < 0 ? height : height - letterDepth - 0.001;

  // Place squares first
  for (i = [0:numSquares - 1]) {
    translate(
      [
        startX + (i * (symbolSize + symbolSpacing)) + symbolSize / 2,
        yPos,
        zPos,
      ]
    ) {
      linear_extrude(height=abs(letterDepth) + 0.002)
        square([symbolSize, symbolSize], center=true);
    }
  }

  // Place circles after squares
  for (i = [0:numCircles - 1]) {
    translate(
      [
        startX + ( (numSquares + i) * (symbolSize + symbolSpacing)) + symbolSize / 2,
        yPos,
        zPos,
      ]
    ) {
      linear_extrude(height=abs(letterDepth) + 0.002)
        circle(d=symbolSize, $fn=32);
    }
  }
}

module LetterTile(letter, points) {
  rotate([letterOnPlate ? 180 : 0, 0, 0])
    translate([0, 0, letterOnPlate ? -height : 0]) {
      if (renderPart == 1) {
        // Render only tiles (white part) with cutouts for letters
        if (letterDepth < 0) {
          // For raised letters, just render the tile base
          color("white") PlaceTile();
        } else {
          // For engraved letters, include the cutouts (subtract the letter shapes)
          difference() {
            color("white") PlaceTile();
            PlaceLetter(letter);
            PlacePointSymbols(points);
          }
        }
      } else if (renderPart == 2) {
        // Render only letters (black part)
        color("black") {
          PlaceLetter(letter);
          PlacePointSymbols(points);
        }
      } else {
        // Render both (default)
        if (letterDepth < 0) {
          union() {
            color("white") PlaceTile();
            color("black") PlaceLetter(letter);
            color("black") PlacePointSymbols(points);
          }
        } else {
          difference() {
            color("white") PlaceTile();
            color("black") PlaceLetter(letter);
            color("black") PlacePointSymbols(points);
          }
        }
      }
    }
}
