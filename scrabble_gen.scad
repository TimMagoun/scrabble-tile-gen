//Custom variables. All measurements in mm

/* [Text] */
//Letter or number on the tile - used only in "oneTile" mode (see below) when index is set to -1
letter="A";
//Secondary text/symbol - used only in "oneTile" mode (see below) when index is set to -1
secondaryText="1";
font="Montserrat:style=Bold";

/* [Tile size] */
//x axis
width=19.75; //.01
//y axis
depth=19.75; //.01
//z axis
height=6; 
//Should be between between 0 and 1/2 the shorted side
radius=1;
//Radius detail
$fn=200;

/* [Text placement] */
//Depth of letter relief (positive for engraved, negative for raised)
letterDepth=-0.4; // 0.1
//Horizontal offset for main letter from the center of the tile
mainLetterXOffset=0; //.01
//Vertical offset for main letter from bottom edge of the tile
mainLetterYOffset=5.5; //.01
//Horizontal offset for secondary text from right edge of the tile
secondaryTextXOffset=-2; //.01
//Vertical offset for secondary text from bottom edge of the tile
secondaryTextYOffset=2; //.01
//Size of the main letter (as a fraction of the tile size)
textScale=0.45; // .01
//Size of secondary text (as a fraction of main text size)
secondaryTextScale=0.3; // .01

/* [Hidden] */
//["letter", "points", number of a given tile in the game]
letterData = [        
    ["A", "1", 5], ["Á", "2", 2], ["B", "3", 2], 
    ["C", "2", 3], ["Č", "4", 1], ["D", "1", 3],
    ["Ď", "8", 1], ["E", "1", 5], ["É", "3", 2], 
    ["Ě", "3", 2], ["F", "5", 1], ["G", "5", 1], 
    ["H", "2", 3], ["I", "1", 4], ["Í", "2", 3], 
    ["J", "2", 2], ["K", "1", 3], ["L", "1", 3], 
    ["M", "2", 3], ["N", "1", 5], ["Ň", "6", 1], 
    ["O", "1", 6], ["Ó", "7", 1], ["P", "1", 3],
    ["R", "1", 3], ["Ř", "4", 2], ["S", "1", 4], 
    ["Š", "4", 2], ["T", "1", 4], ["Ť", "7", 1], 
    ["U", "2", 3], ["Ú", "5", 1], ["Ů", "4", 1], 
    ["V", "1", 4], ["X", "10", 1], ["Y", "2", 2], 
    ["Ý", "4", 2], ["Z", "2", 2], ["Ž", "4", 1], ["", "", 2]
];



//Calculate text sizes
textSize = width>depth ? depth*textScale : width*textScale;
secondaryTextSize = textSize * secondaryTextScale;

// Modes:
/* [Modes] */
mode = 1; // [1:oneTile - set for export via script, 2:allTiles]
index = -1;
if (mode == 1){
    oneTile();
} else if (mode == 2){
    allTiles();
} else {
    oneTile();
}


//Make tile(s):
//----------------------------------------
module oneTile() {
    selectedLetter = index < 0 ? letter : letterData[index][0];
    selectedPoints = index < 0 ? secondaryText : letterData[index][1];

    LetterTile(selectedLetter, selectedPoints);
}

module allTiles() {
    for (i = [0 : len(letterData) - 1]) {
        translate([
            (i % 10) * (width + 2), 
            -floor(i / 10) * (depth + 2),
            0
        ])
        LetterTile(letterData[i][0], str(letterData[i][1]));
    }
}

//-----------------------------------------


module Tile(){
    linear_extrude(height=height, center=true)
        offset(r=radius)
            square([width - 2*radius, depth - 2*radius], center=true);
}

module PlaceTile() {
        translate([0,0,height/2]) Tile();
}

module PlaceLetter(letter) {
    translate([
            mainLetterXOffset, 
            -depth/2 + mainLetterYOffset, 
            letterDepth<0 ? height : height-letterDepth
        ]) {
            linear_extrude(height=abs(letterDepth), convexity=5)
                scale([1,1,1])
                text(letter, 
                     size=textSize,
                     font=font,
                     halign="center",
                     valign="bottom");
    }
}

module PlaceSecondaryText(secondaryText){
    translate([
        width/2 + secondaryTextXOffset, 
        -depth/2 + secondaryTextYOffset, 
        letterDepth<0 ? height : height-letterDepth
    ]) {
        linear_extrude(height=abs(letterDepth), convexity=5)
            scale([1,1,1])
            text(secondaryText, 
                 size=secondaryTextSize,
                 font=font,
                 halign="right",
                 valign="bottom");
    }
}

module LetterTile(letter, secondText) {
    if (letterDepth < 0) {
         union() {
            color("white") PlaceTile();            
            color ("black") PlaceLetter(letter);
            color ("black") PlaceSecondaryText(secondText);
        }
    } 
    else {
        difference() {
            color("white") PlaceTile();            
            color("black") PlaceLetter(letter);
            color("black") PlaceSecondaryText(secondText);
        }
    }
}
