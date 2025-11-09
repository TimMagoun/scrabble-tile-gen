//Scrabble Board Grid Generator
//All measurements in mm

/* [Grid Parameters] */
//Number of cells horizontally
gridWidth = 15;
//Number of cells vertically  
gridHeight = 15;
// Cell width (center to center)
cellWidth = 19; //.01
// Cell height (center to center)
cellHeight = 17; //.01
//Width of grid lines
lineWidth = 2; //.01
//Height/thickness of grid lines
lineHeight = 2; //.01
// Center gap in mm to notch out around intersections
centerGap = 2; //.1
// Center gap keep in mm to connect everything
centerKeep = 0.4; //.1

/* [Hidden] */
//Calculate total dimensions
totalWidth = gridWidth * cellWidth + lineWidth;
totalHeight = gridHeight * cellHeight + lineWidth;
testBox = 90;
// Generate the grid
intersection() {
  grid();
  //   cube([2 * testBox, 2 * testBox, 100], center=true);
}

module grid() {
  difference() {
    union() {
      // Horizontal lines
      for (i = [0:gridHeight]) {
        translate([-lineWidth / 2, i * (cellHeight) - lineWidth / 2, 0])
          cube([totalWidth, lineWidth, lineHeight]);
      }

      // Vertical lines  
      for (j = [0:gridWidth]) {
        translate([j * (cellWidth) - lineWidth / 2, -lineWidth / 2, 0])
          cube([lineWidth, totalHeight, lineHeight]);
      }
    }

    // Notch out center gaps at intersections
    union() {
      for (i = [0:gridHeight]) {
        translate([cellWidth * (i + 0.5) - centerGap / 2, -cellHeight / 2, centerKeep])
          cube([centerGap, totalHeight + cellHeight, lineHeight + 1]);
      }

      for (j = [0:gridWidth]) {
        translate([-cellWidth / 2, cellHeight * (j + 0.5) - centerGap / 2, centerKeep])
          cube([totalWidth + cellWidth, centerGap, lineHeight + 1]);
      }

      // Complete cut at x=6.5
      translate([6.5 * cellWidth - centerGap / 2, -cellHeight / 2, -1])
        cube([centerGap, totalHeight + cellHeight, lineHeight + 2]);

      // Complete cut at y=7.5
      translate([-cellWidth / 2, 7.5 * cellHeight - centerGap / 2, -1])
        cube([totalWidth + cellWidth, centerGap, lineHeight + 2]);
    }
  }
}
