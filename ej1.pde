import g4p_controls.*;

import gab.opencv.*;
/**
 * Load and Display 
 * 
 * Images can be loaded and displayed to the screen at their actual size
 * or any other size. 
 */
converter menu;
void setup() {
  size(displayWidth, displayHeight);
  surface.setResizable(true);
  
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  menu = new converter("IceKing.png");
  menu.to_grayscale();
  int[] a = {0, 255};
  int[] b = {255, 0};
  menu.brightness(2, a, b);
}



void draw() {
  // Displays the image at its actual size at point (0,0)
  menu.drawImage(); 
  menu.drawHistogram();
}
