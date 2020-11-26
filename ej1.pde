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
  GButton btn0 = new GButton(this, 10, 10, 100, 30, "First Button");
  GButton btn1 = new GButton(this, 120, 10, 100, 30, "Second Button");
  GButton btn2 = new GButton(this, 220, 10, 100, 30, "Second Button");
  GButton btn3 = new GButton(this, 320, 10, 100, 30, "Second Button");
  GButton btn4 = new GButton(this, 420, 10, 100, 30, "Second Button");
  GButton btn5 = new GButton(this, 520, 10, 100, 30, "Second Button");
  GButton btn6 = new GButton(this, 520, 10, 100, 30, "Second Button");
  GButton btn7 = new GButton(this, 620, 10, 100, 30, "Second Button");
  GButton btn8 = new GButton(this, 720, 10, 100, 30, "Second Button");
  GButton btn9 = new GButton(this, 830, 10, 100, 30, "Second Button");
  int window_height = displayHeight - (int)(0.05 * displayWidth);
  int window_width = (int)displayWidth;
  surface.setSize(window_width, window_height);
  surface.setResizable(true);
   background(255);
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  menu = new converter("IceKing.png");
   menu.second_img = menu.img.copy();
  menu.to_grayscale();
  int[] a = {0, 255};
  int[] b = {255, 0};
 
  //menu.brightness(2, a, b );
  //int[] c = {0, 40, 255};
  //int[] d = {0, 255, 255};
  //menu.brightness(2, c, d );
  
  menu.load_second_image("descarga.jpg");
  menu.specify_hist();
  //menu.equalize_hist();
}

int i = 0;

void draw() {
  // Displays the image at its actual size at point (0,0)
   menu.reload_histogram();
   menu.reload_acc_histogram();
   menu.drawImage();
   //menu.drawHistogram();
}
