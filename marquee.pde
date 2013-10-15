/**
 * code based on:
 * Mirror 
 * by Daniel Shiffman.  
 *
 */

import processing.video.*;


// Size of each cell in the grid
int cellSize = 55;
// Number of columns and rows in our system
int cols, rows;
// Variable for capture device
Capture video;
float noiseScale= 0.003;
float noiseVal = 0;
float br = 0;
float noiseIncrement = 0.001;



void setup() {
  size(640, 480);
  frameRate(30);
  cols = width / cellSize;
  rows = height / cellSize;
  //colorMode(RGB, 255, 255, 255, 100);

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, width, height);

  // Start capturing the images from the camera
  video.start();  
  

}


void draw() { 
  if (video.available()) {
    video.read();
    video.loadPixels();
    noiseIncrement ++;

    // Begin loop for columns
    for (int i = 0; i < cols; i++) {
      // Begin loop for rows
      for (int j = 0; j < rows; j++) {

        // Where are we, pixel-wise?
        int x = i*cellSize;
        int y = j*cellSize;
        int loc = (video.width - x - 1) + y*video.width; // Reversing x to mirror the image

        //take the brightness value of each pixel
        br = brightness(video.pixels[loc]);
        int brPrint = int(br);
       
        br = map(br, 0, 255, 0, 55);

        //get a noise value and map it
        noiseVal = noise((i+1)*noiseScale*noiseIncrement, (j+1)*noiseScale*noiseIncrement);
        noiseVal = map(noiseVal, 0, 1, 0, 200);



        // Make a new color with an alpha component
        color c = color(br+noiseVal);
        drawRect(x, y, c);
      }
    }
    println();
  }
}


void drawRect(int xA, int yA, int col) {
  pushMatrix();
    translate(xA+cellSize/2, yA+cellSize/2);
    // Rotation formula based on brightness
    //rotate((2 * PI * brightness(c) / 255.0));
    rectMode(CENTER);
    fill(col);
    noStroke();
    // Rects are larger than the cell for some overlap
    rect(0, 0, cellSize, cellSize);
  popMatrix();
}

